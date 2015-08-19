module ActiveTriples
  module Solrizer
    class IndexingService
      # include ::Solrizer::Common
      attr_reader :object

      def initialize(obj)
        @object = obj
      end

      def self.model_solr_name
        # @model_solr_name ||= ActiveTriples::Solrizer::SolrQueryBuilder.solr_name("at_model", :displayable)
        @model_solr_name ||= :at_model_ssi
      end

      def self.profile_solr_name
        # @profile_solr_name ||= ActiveTriples::Solrizer::SolrQueryBuilder.solr_nßame("object_profile", :displayable)
        @profile_solr_name ||= :object_profile_ss
      end

      def self.profile_service
        ProfileIndexingService
      end

      def self.properties_service
        PropertiesIndexingService
      end

      # Creates a solr document hash for the {#object}
      # @yield [Hash] yields the solr document
      # @return [Hash] the solr document
      def generate_solr_document
        solr_doc = {}
        # Solrizer.set_field(solr_doc, 'system_create', c_time, :stored_sortable)
        # Solrizer.set_field(solr_doc, 'system_modified', m_time, :stored_sortable)
        solr_doc.merge!(SOLR_DOCUMENT_ID.to_sym => object.id)
        solr_doc.merge!(self.class.model_solr_name => object.class.to_s)
        solr_doc.merge!(self.class.profile_solr_name => self.class.profile_service.new(object).export)
        solr_doc.merge!(self.class.properties_service.new(object).export)
        yield(solr_doc) if block_given?
        solr_doc
      end

      def self.load_from_solr(id, cascade = false, processed_ids = nil)
        query = ActiveTriples::Solrizer::SolrQueryBuilder.id_query(id)
        results = ActiveTriples::Solrizer::SolrService.query(query)
        return nil unless results.size > 0
        solr_doc = results.first
        load_from_solr_document(solr_doc, cascade, processed_ids)
      end

      def self.load_from_solr_document(solr_doc, cascade = false, processed_ids = nil)
        obj = profile_service.new.import(solr_doc[profile_solr_name.to_s], solr_doc[model_solr_name.to_s])
        obj = cascade_load_from_solr(obj, processed_ids) if cascade
        yield(obj) if block_given?
        obj
      end

      def self.cascade_load_from_solr(obj, processed_ids = {})
        processed_ids = {} if processed_ids.nil?
        processed_ids[obj.id] = obj
        attrs_config = obj._active_triples_config
        attrs_config.each do |key, config|
          next if config.class_name.nil?
          values = obj.get_values(key)
          next if values.nil? || values.size < 1
          replacement_values = []
          values.each do |test_id|
            replacement_value = test_id
            if test_id.is_a? String
              replacement_value = processed_ids[test_id] if processed_ids.key? test_id
              replacement_value = load_from_solr(test_id, true, processed_ids) unless processed_ids.key? test_id
              replacement_value = test_id if replacement_value.nil?
            end
            replacement_values << replacement_value
            processed_ids[test_id] = replacement_value
          end
          obj.set_value(key, replacement_values)
        end
        obj
      end

      #   protected
      #
      #   def c_time
      #     c_time = object.create_date.present? ? object.create_date : DateTime.now
      #     c_time = DateTime.parse(c_time) unless c_time.is_a?(DateTime)
      #     c_time
      #   end
      #
      #   def m_time
      #     m_time = object.modified_date.present? ? object.modified_date : DateTime.now
      #     m_time = DateTime.parse(m_time) unless m_time.is_a?(DateTime)
      #     m_time
      #   end

    end
  end
end
