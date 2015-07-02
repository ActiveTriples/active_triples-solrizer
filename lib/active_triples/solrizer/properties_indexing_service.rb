module ActiveTriples::Solrizer
  class PropertiesIndexingService
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
        next unless cfg.respond_to?( :behaviors ) && !cfg.behaviors.nil? && cfg.behaviors.include?( :indexed )
        values = attrs_values[key]
        next if values.first.nil?

        behaviors = parse_behaviors cfg.behaviors
        encoded_data_type = cfg.respond_to?( :data_type ) ? encode_data_type( cfg.data_type, values )
                                                          : encode_data_type( nil, values )
        solr_fieldname = build_solr_fieldname( key, encoded_data_type, behaviors )
        solr_value = build_solr_value( values, encoded_data_type, behaviors )
        solr_doc[solr_fieldname.to_sym] = solr_value

        next unless behaviors[:sortable] && encoded_data_type == "t"

        solr_fieldname = "#{key}_sort_ss"
        solr_fieldname = "#{solr_fieldname}m" if behaviors[:multiple]
        solr_doc[solr_fieldname.to_sym] = solr_value
      end

      solr_doc
    end

private
    def encode_data_type( data_type, values )
      return 't' if data_type == :text
      return 's' if data_type == :string
      return 'i' if data_type == :int
      return 'f' if data_type == :float
      guess_data_type( values )
    end

    def guess_data_type( values )
      data_type = "t"   # default to text which tokenizes a string
      data_type = "i"  if values.first.is_a?( Fixnum ) # && !sortable
      data_type = "f"  if values.first.is_a?( Float )  # && !sortable
      data_type
    end

    def parse_behaviors( cfg_behaviors )
      behaviors = {}
      behaviors[:sortable] = cfg_behaviors.include?( :sortable ) ? true : false
      behaviors[:range]    = cfg_behaviors.include?( :range    ) ? true : false
      behaviors[:multiple] = cfg_behaviors.include?( :multiple ) ? true : false
      behaviors
    end

    def build_solr_fieldname( key, encoded_data_type, behaviors )
      solr_fieldname = key + "_" + encoded_data_type
      solr_fieldname += "t"   if behaviors[:range]
      solr_fieldname += "s"   unless encoded_data_type == "t" && behaviors[:sortable]
      solr_fieldname += "i"
      solr_fieldname += "m"   if behaviors[:multiple]
      solr_fieldname
    end

    def build_solr_value( values, encoded_data_type, behaviors )
      if behaviors[:multiple]
        solr_value = values.to_a
        solr_value.collect! { |v| v.id }  if values.first.is_a? ActiveTriples::Resource
      elsif values.size == 1
        solr_value = values.first
        solr_value = solr_value.id        if solr_value.is_a? ActiveTriples::Resource
      elsif encoded_data_type == "t" || encoded_data_type == "s"
        solr_value.collect! { |v| v.id }  if values.first.is_a? ActiveTriples::Resource
        solr_value = solr_value.to_s   # TODO Is this how to handle multiple values when expecting one value?
      elsif encoded_data_type == "i" || encoded_data_type == "f"
        solr_value = values.first   # can't do anything for multiple numbers when multiple values are not supported, so just return first value
      end
      solr_value
    end

  end
end