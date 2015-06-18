module ActiveTriples::Solrizer
  class ProfileIndexingService
    def initialize(object)
      @object = object
    end

    def export
      # @object.serializable_hash.to_json
      attributes(@object).to_json
    end

    def attributes(obj)
      attrs = obj.attributes
      attrs.each do |k,v|
        next unless v.is_a? Array
        next unless v.first.is_a? ActiveTriples::Resource
        attrs[k] = v.first.id
      end
      attrs
    end

  end
end