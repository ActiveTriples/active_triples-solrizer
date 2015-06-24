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
        next unless cfg.respond_to?( :indexed ) && cfg.indexed

        values = attrs_values[key]
        next if values.first.nil?

        sortable = cfg.respond_to?( :sortable ) ? cfg.sortable : false
        multiple = cfg.respond_to?( :multiple ) ? cfg.multiple : false

        type = "t"   # default
        type = "i"  if values.first.is_a?( Fixnum ) && !sortable
        type = "it" if values.first.is_a?( Fixnum ) &&  sortable
        type = "f"  if values.first.is_a?( Float )  && !sortable
        type = "ft" if values.first.is_a?( Float )  &&  sortable


        solr_fieldname = key + "_" + type
        solr_fieldname += "s"   unless type == "t" && sortable
        solr_fieldname += "i"
        solr_fieldname += "m"   if multiple

# solr_fieldname = "#{key}_#{type}s" unless type == "t" && sortable
# solr_fieldname = "#{solr_fieldname}i"
# solr_fieldname = "#{solr_fieldname}m" if multiple


        # TODO ??? Would it hurt to determine multiple from the number of actual values ???
        #      if values.size > 1, then multiple = true
        #      so some docs might have creator_tsim and others creator_tsi
        # This will be fine for general search where the field is not specified.
        # I guess the problem will be in a specific search by field, e.g. creator_tsi:George*

        if multiple
          solr_value = values.to_a
          solr_value.collect! { |v| v.id }  if values.first.is_a? ActiveTriples::Resource
        elsif values.size == 1
          solr_value = values.first
          solr_value = solr_value.id        if solr_value.is_a? ActiveTriples::Resource
        elsif type == "t"
          solr_value.collect! { |v| v.id }  if values.first.is_a? ActiveTriples::Resource
          solr_value = solr_value.to_s   # TODO Is this how to handle multiple values when expecting one value?
        elsif type == "i" || type == "f"
          next   # can't do anything for multiple numbers when multiple values are not supported
        end

        solr_doc[solr_fieldname] = solr_value

        next unless sortable && type == "t"

        solr_fieldname = "#{key}_sort_ss"
        solr_fieldname = "#{solr_fieldname}m" if multiple

        solr_doc[solr_fieldname] = solr_value
      end

      solr_doc
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

  end
end