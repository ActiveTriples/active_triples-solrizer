module ActiveTriples::Solrizer
  class PropertiesIndexingService

    # supported types:
    #  :text        - tokenized text
    #  :text_en     - tokenized English text
    #  :string      - non-tokenized string
    #  :integer
    #  :date        - format for this date field is of the form 1995-12-31T23:59:59Z; Optional fractional seconds are allowed: 1995-12-31T23:59:59.999Z
    #  :long
    #  :double
    #  :float
    #  :boolean
    #  :coordinate  - used to index the lat and long components for the "location"
    #  :location
    #  :guess       - allow guessing of the type based on the type of the property value

    # supported modifiers:
    #  :indexed     - [all types except :coordinate] searchable, but not returned in solr doc unless also has :stored modifier
    #  :stored      - [all types except :coordinate] returned in solr doc, but not searchable unless also has :indexed modifier
    #  :multiValued - [all types except :boolean, :coordinate] NOTE: if not specified and multiple values exist, only the first value is included in the solr doc
    #  :sortable    - [all types except :boolean, :coordinate, :location] numbers are stored as trie version of numeric type; :string, :text, :text_XX have an extra alphaSort field
    #  :range       - [all numeric types including :integer, :date, :long, :double, :float];  optimize for range queries
    #  :vectored    - [valid for :text, :text_XX only]


    def initialize(object)
      @object = object
    end

    def export
      solr_fields(@object)
    end

    def solr_fields(obj)
      attrs_values = obj.attributes
      solr_doc = {}
      obj._active_triples_config.each do |key,cfg|
        modifiers = parse_modifiers cfg.behaviors
        next unless modifiers[:indexed] || modifiers[:stored]
        values = attrs_values[key]
        values = values.to_a if Object::ActiveTriples.const_defined?("Relation") && values.kind_of?(ActiveTriples::Relation)
        next if values.nil? || !values.is_a?(Array) || values.first.nil?

        encoded_data_type = encode_data_type( cfg.type, modifiers, values )
        solr_fieldname = build_solr_fieldname( key, encoded_data_type, modifiers )
        solr_value = build_solr_value( values, encoded_data_type, modifiers )
        solr_doc[solr_fieldname.to_sym] = solr_value

        next unless modifiers[:sortable] && [:t,:te,:s].include?( encoded_data_type )

        solr_fieldname = "#{key}_ssort"
        solr_doc[solr_fieldname.to_sym] = solr_value
      end

      solr_doc
    end

private
    def encode_data_type( data_type, modifiers, values )
      return :t           if data_type == :text
      return :te          if data_type == :text_en
      return :s           if data_type == :string
      return :it          if data_type == :integer && ( modifiers[:sortable] || modifiers[:range] )
      return :i           if data_type == :integer
      return :dtt         if data_type == :date    && ( modifiers[:sortable] || modifiers[:range] )
      return :dt          if data_type == :date
      return :lt          if data_type == :long    && ( modifiers[:sortable] || modifiers[:range] )
      return :l           if data_type == :long
      return :dbt         if data_type == :double  && ( modifiers[:sortable] || modifiers[:range] )
      return :db          if data_type == :double
      return :ft          if data_type == :float   && ( modifiers[:sortable] || modifiers[:range] )
      return :f           if data_type == :float
      return :b           if data_type == :boolean
      return :coordinate  if data_type == :coordinate
      return :location    if data_type == :location
      return guess_data_type( modifiers, values ) if data_type == :guess
      nil
    end

    def guess_data_type( modifiers, values )
      data_type = :t   # default to text which tokenizes a string
      data_type = :i   if values.first.is_a?( Fixnum )
      data_type = :it  if values.first.is_a?( Fixnum )  && ( modifiers[:sortable] || modifiers[:range] )
      data_type = :l   if values.first.is_a?( Bignum )
      data_type = :lt  if values.first.is_a?( Bignum )  && ( modifiers[:sortable] || modifiers[:range] )
      data_type = :f   if values.first.is_a?( Float )
      data_type = :ft  if values.first.is_a?( Float )   && ( modifiers[:sortable] || modifiers[:range] )
      data_type = :b   if values.first.is_a?( TrueClass ) || values.first.is_a?( FalseClass )
      data_type = :dt  if date? values.first
      data_type
    end

    def parse_modifiers( cfg_behaviors )
      modifiers = {}
      return modifiers if cfg_behaviors.nil?
      modifiers[:indexed]     = cfg_behaviors.include?( :indexed     ) ? true : false
      modifiers[:stored]      = cfg_behaviors.include?( :stored      ) ? true : false
      modifiers[:multiValued] = cfg_behaviors.include?( :multiValued ) ? true : false
      modifiers[:sortable]    = cfg_behaviors.include?( :sortable    ) ? true : false
      modifiers[:range]       = cfg_behaviors.include?( :range       ) ? true : false
      modifiers[:vectored]    = cfg_behaviors.include?( :vectored    ) ? true : false
      modifiers
    end


    def build_solr_fieldname( key, encoded_data_type, modifiers )
      solr_fieldname = key + "_" + encoded_data_type.to_s
      return solr_fieldname if encoded_data_type == :coordinate  # no supported modifiers
      solr_fieldname += "s"   if modifiers[:stored]
      solr_fieldname += "i"   if modifiers[:indexed]
      solr_fieldname += "m"   if modifiers[:multiValued] && encoded_data_type != :b
      solr_fieldname += "v"   if modifiers[:vectored] && [:t,:te].include?( encoded_data_type )
      solr_fieldname
    end

    def build_solr_value( values, encoded_data_type, modifiers )
      if modifiers[:multiValued] && encoded_data_type != :b
        solr_value = values.to_a
        solr_value.collect! { |v| v.is_a?( ActiveTriples::Resource ) ? v.id : v }
      else
        # grab first value only and ignore the rest
        solr_value = values.first
        solr_value = solr_value.id        if solr_value.is_a? ActiveTriples::Resource
      end
      solr_value
    end

    def date? test_date
      return false unless test_date.is_a? String
      begin
        Date.parse(test_date)
      rescue ArgumentError
        return false
      end
      return true
    end
  end
end