require 'json'

module ActiveTriples::Solrizer
  class ProfileIndexingService
    def initialize(object)
      @object = object
    end

    def import( object_profile, object_class=nil )
      raise ArgumentError, 'object_profile must not be nil'  if
          object_profile == nil

      raise ArgumentError, 'object_class must not be nil if @object is nil'  if
          object_class == nil && @object == nil

      raise ArgumentError, 'object_class must be same as class for @object'  unless
          object_class == nil || @object == nil || object_class == @object.class

      # @object.deserializable_json(object_profile)

      attrs = JSON(object_profile)
      object_class ||= @object.class
      @object = object_class.new(attrs['id'])
      set_attributes(@object,attrs)
      @object
    end

    def set_attributes(obj,attrs)
      attrs.each do |k,v|
        next if k == 'id'
        obj.set_value( k, v )
      end
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