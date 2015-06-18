module ActiveTriples::Solrizer
  class PropertiesIndexingService
    def initialize(object)
      @object = object
    end

    def export
      solr_fields(@object)
    end

    def solr_fields(obj)
binding.pry
      attrs_values = obj.attributes
      solr_doc = {}
      obj._active_triples_config.map do |c|
        next unless c.respond_to? indexed

        term = c.term
        values = attrs_values[term]
        next if values.first.nil?

        sortable = c.respond_to? sortable ? c.sortable : false
        multiple = c.respond_to? multiple ? c.multiple : false

        type = "i" if values.first.is_a? Fixnum
        type = "f" if values.first.is_a? Float
        type = "t" if values.first.is_a? String

        solr_fieldname = "#{term}_#{type}si"
        solr_fieldname = "#{solr_fieldname}m" if multiple

        # TODO get value
        #   -- values.first for single value && values.size == 1
        #   -- add each for multiple values && values.size >= 1
        #   -- collapse to one value if single value && values.size > 1

        # TODO add 1..m to solr doc
        # TODO add sort version if sortable
      end

      #
      #
      # attrs = obj.attributes
      # attrs.each do |k,v|
      #   next unless v.is_a? Array
      #   next unless v.first.is_a? ActiveTriples::Resource
      #   attrs[k] = v.first.id
      # end
      # attrs

      solr_doc
    end

  end
end