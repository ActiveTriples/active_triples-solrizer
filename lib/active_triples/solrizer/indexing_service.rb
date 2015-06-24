module ActiveTriples::Solrizer
  class IndexingService
    include ::Solrizer::Common
    attr_reader :object

    def initialize(obj)
      @object = obj
    end

    def self.profile_solr_name
      # @profile_solr_name ||= ActiveFedora::SolrQueryBuilder.solr_name("object_profile", :displayable)
      @profile_solr_name ||= :object_profile_ss
    end

    def profile_service
      ProfileIndexingService
    end

    def properties_service
      PropertiesIndexingService
    end

    # def rdf_service
    #   RDF::IndexingService
    # end

    # Creates a solr document hash for the {#object}
    # @yield [Hash] yields the solr document
    # @return [Hash] the solr document
    def generate_solr_document
      solr_doc = {}
      # Solrizer.set_field(solr_doc, 'system_create', c_time, :stored_sortable)
      # Solrizer.set_field(solr_doc, 'system_modified', m_time, :stored_sortable)
      solr_doc.merge!(SOLR_DOCUMENT_ID.to_sym => object.id)
      solr_doc.merge!(:at_model_ssi => object.class.to_s)   # TODO dynamic for now, but probably should be static solr field
      solr_doc.merge!(self.class.profile_solr_name => profile_service.new(object).export)
      solr_doc.merge!(properties_service.new(object).export)
      yield(solr_doc) if block_given?
      solr_doc
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
