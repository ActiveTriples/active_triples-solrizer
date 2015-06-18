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

        type = "t"   # default
        type = "i" if values.first.is_a? Fixnum
        type = "f" if values.first.is_a? Float

        solr_fieldname = "#{term}_#{type}si"
        solr_fieldname = "#{solr_fieldname}m" if multiple


        # TODO ??? Would it hurt to determine multiple from the number of actual values ???
        #      if values.size > 1, then multiple = true
        #      so some docs might have creator_tsim and others creator_tsi
        # This will be fine for general search where the field is not specified.
        # I guess the problem will be in a specific search by field, e.g. creator_tsi:George*

        if multiple
          solr_value = values
        elsif values.size == 1
          solr_value = values.first
        elsif type == "t"
          solr_value = values.to_s   # TODO Is this how to handle multiple values
        elsif type == "i" || type == "f"
          next   # can't do anything for multiple numbers when multiple values are not supported
        end

        solr_doc[solr_fieldname] = solr_value

        next unless sortable && type == "t"

        solr_fieldname = "#{term}_ssi"
        solr_fieldname = "#{solr_fieldname}m" if multiple

        solr_doc[solr_fieldname] = solr_value
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