module ActiveTriples::Solrizer
  class IndexingService
    include ::Solrizer::Common
    attr_reader :object

    def initialize(obj)
      @object = obj
    end

        # def self.profile_solr_name
        #   @profile_solr_name ||= ActiveFedora::SolrQueryBuilder.solr_name("object_profile", :displayable)
        # end
        #
        # def profile_service
        #   ProfileIndexingService
        # end
        #
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
      # Solrizer.set_field(solr_doc, 'active_fedora_model', object.class.inspect, :stored_sortable)
      # solr_doc.merge!(QueryResultBuilder::HAS_MODEL_SOLR_FIELD => object.has_model)
      solr_doc.merge!(SOLR_DOCUMENT_ID.to_sym => object.id)
      solr_doc.merge!('ID' => object.id)
      # solr_doc.merge!(self.class.profile_solr_name => profile_service.new(object).export)
      # object.attached_files.each do |name, file|
      #   solr_doc.merge! file.to_solr(solr_doc, name: name.to_s)
      # end
      # solr_doc = solrize_relationships(solr_doc)
      # solr_doc = solrize_rdf_assertions(solr_doc)
      # yield(solr_doc) if block_given?
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
    #
    #   # Serialize the datastream's RDF relationships to solr
    #   # @param [Hash] solr_doc @deafult an empty Hash
    #   def solrize_relationships(solr_doc = Hash.new)
    #     object.class.outgoing_reflections.values.each do |reflection|
    #       solr_key = reflection.solr_key
    #       Array(object[reflection.foreign_key]).compact.each do |v|
    #         ::Solrizer::Extractor.insert_solr_field_value(solr_doc, solr_key, v )
    #       end
    #     end
    #     solr_doc
    #   end
    #
    #   # Serialize the resource's RDF relationships to solr
    #   # @param [Hash] solr_doc @deafult an empty Hash
    #   def solrize_rdf_assertions(solr_doc = Hash.new)
    #     solr_doc.merge rdf_service.new(object).generate_solr_document
    #   end
    # end
  end
end


#
#     # @param obj [#resource, #rdf_subject] the object to build an solr document for. Its class must respond to 'properties'
#     def initialize(obj)
#       @object = obj
#     end
#
#     # Creates a solr document hash for the rdf assertions of the {#object}
#     # @yield [Hash] yields the solr document
#     # @return [Hash] the solr document
#     def generate_solr_document(prefix_method = nil)
#       solr_doc = add_assertions(prefix_method)
#       yield(solr_doc) if block_given?
#       solr_doc
#     end
#
#     protected
#
#     def add_assertions(prefix_method, solr_doc = {})
#       fields.each do |field_key, field_info|
#         solr_field_key = solr_document_field_name(field_key, prefix_method)
#         Array(field_info[:values]).each do |val|
#           append_to_solr_doc(solr_doc, solr_field_key, field_info, val)
#         end
#       end
#       solr_doc
#     end
#
#     # Override this in order to allow one field to be expanded into more than one:
#     #   example:
#     #     def append_to_solr_doc(solr_doc, field_key, field_info, val)
#     #       Solrizer.set_field(solr_doc, 'lcsh_subject_uri', val.to_uri, :symbol)
#     #       Solrizer.set_field(solr_doc, 'lcsh_subject_label', val.to_label, :searchable)
#     #     end
#     def append_to_solr_doc(solr_doc, solr_field_key, field_info, val)
#       self.class.create_and_insert_terms(solr_field_key,
#                                          solr_document_field_value(val),
#                                          field_info[:behaviors], solr_doc)
#     end
#
#     def solr_document_field_name(field_key, prefix_method)
#       if prefix_method
#         prefix_method.call(field_key)
#       else
#         field_key.to_s
#       end
#     end
#
#     def solr_document_field_value(val)
#       case val
#         when ::RDF::URI
#           val.to_s
#         when ActiveTriples::Resource
#           val.node? ? val.rdf_label : val.rdf_subject.to_s
#         else
#           val
#       end
#     end
#
#     def resource
#       object.resource
#     end
#
#     def properties
#       object.class.properties
#     end
#
#     def index_config
#       object.class.index_config
#     end
#
#     # returns a Hash, e.g.: {field => { values: [], type: :something, behaviors: [] }, ...}
#     def fields
#       field_map = {}.with_indifferent_access
#
#       index_config.each do |name, index_field_config|
#         type = index_field_config.data_type
#         behaviors = index_field_config.behaviors
#         next unless type and behaviors
#         next if kind_of_af_base?(name)
#         field_map[name] = { values: find_values(name), type: type, behaviors: behaviors}
#       end
#       field_map
#     end
#
#     def kind_of_af_base?(name)
#       config = properties[name.to_s]
#       config && config[:class_name] && config[:class_name] < ActiveFedora::Base
#     end
#
#     def find_values(name)
#       object.send(name) || []
#     end
#   end
# end



# module Triannon
#   class SolrWriter
#
#     # DO NOT CALL before anno is stored: the graph should have an assigned url for the
#     #   @id of the root;  it shouldn't be a blank node
#     #
#     # Convert a OA::Graph object into a Hash suitable for writing to Solr.
#     #
#     # @param [OA::Graph] triannon_graph a populated OA::Graph object for a *stored* anno
#     # @return [Hash] a hash to be written to Solr, populated appropriately
#     def self.solr_hash(triannon_graph)
#       doc_hash = {}
#       triannon_id = triannon_graph.id_as_url
#       if triannon_id
#         # chars in Solr/Lucene query syntax are a big pain in Solr id fields, so we only use
#         # the uuid portion of the Triannon anno id, not the full url
#         solr_id = triannon_id.sub(ActiveTriples::Solrizer.configuration.base_url, "")  # TODO Where to get base_uri -- from subclass Resource?
#         doc_hash[:id] = solr_id.sub(/^\/*/, "") # remove first char slash(es) if present
#
#         # use short strings for motivation field
#         doc_hash[:motivation] = triannon_graph.motivated_by.map { |m| m.sub(RDF::Vocab::OA.to_s, "") }
#
#         # date field format: 1995-12-31T23:59:59Z; or w fractional seconds: 1995-12-31T23:59:59.999Z
#         if triannon_graph.annotated_at
#           begin
#             dt = Time.parse(triannon_graph.annotated_at)
#             doc_hash[:annotated_at] = dt.iso8601 if dt
#           rescue ArgumentError
#             # ignore invalid datestamps
#           end
#         end
#         #doc_hash[:annotated_by_stem] # not yet implemented
#
#         doc_hash[:target_url] = triannon_graph.predicate_urls RDF::Vocab::OA.hasTarget
#         # TODO: recognize more target types
#         doc_hash[:target_type] = ['external_URI'] if doc_hash[:target_url].size > 0
#
#         doc_hash[:body_url] = triannon_graph.predicate_urls RDF::Vocab::OA.hasBody
#         doc_hash[:body_type] = []
#         doc_hash[:body_type] << 'external_URI' if doc_hash[:body_url].size > 0
#         doc_hash[:body_chars_exact] = triannon_graph.body_chars.map {|bc| bc.strip}
#         doc_hash[:body_type] << 'content_as_text' if doc_hash[:body_chars_exact].size > 0
#         doc_hash[:body_type] << 'no_body' if doc_hash[:body_type].size == 0
#
#         doc_hash[:anno_jsonld] = triannon_graph.jsonld_oa
#       end
#       doc_hash
#     end
#
#     attr_accessor :rsolr_client
#
#     def initialize
#       @rsolr_client = RSolr.connect :url => ActiveTriples::Solrizer.configuration.solr_url
#       @logger = Rails.logger
#       @max_retries = ActiveTriples::Solrizer.configuration.max_solr_retries
#       @base_sleep_seconds = ActiveTriples::Solrizer.configuration.base_sleep_seconds
#       @max_sleep_seconds = ActiveTriples::Solrizer.configuration.max_sleep_seconds
#     end
#
#     # Convert the OA::Graph to a Solr document hash, then call RSolr.add
#     #  with the doc hash
#     # @param [OA::Graph] tgraph anno represented as a OA::Graph
#     def write(tgraph)
#       doc_hash = self.class.solr_hash(tgraph) if tgraph && !tgraph.id_as_url.empty?
#       add(doc_hash) if doc_hash && !doc_hash.empty?
#     end
#
#     # Add the document to Solr, retrying if an error occurs.
#     # See https://github.com/ooyala/retries for info on with_retries.
#     # @param [Hash] doc a Hash representation of the Solr document to be added
#     def add(doc)
#       id = doc[:id]
#
#       handler = Proc.new do |exception, attempt_cnt, total_delay|
#         @logger.debug "#{exception.inspect} on Solr add attempt #{attempt_cnt} for #{id}"
#         if exception.kind_of?(RSolr::Error::Http)
#           # Note there are extra shenanigans b/c RSolr hijacks the Solr error to return RSolr Error
#           fail ActiveTriples::SearchError.new("error adding doc #{id} to Solr #{doc.inspect}; #{exception.message}", exception.response[:status], exception.response[:body])
#         elsif exception.kind_of?(StandardError)
#           fail ActiveTriples::SearchError.new("error adding doc #{id} to Solr #{doc.inspect}; #{exception.message}")
#         end
#       end
#
#       with_retries(:handler => handler,
#                    :max_tries => @max_retries,
#                    :base_sleep_seconds => @base_sleep_seconds,
#                    :max_sleep_seconds => @max_sleep_seconds) do |attempt|
#         @logger.debug "Solr add attempt #{attempt} for #{id}"
#         # add it and commit within 0.5 seconds
#         @rsolr_client.add(doc, :add_attributes => {:commitWithin => 500})
#         #  RSolr throws RSolr::Error::Http for any Solr response without status 200 or 302
#         @logger.info "Successfully indexed #{id} to Solr on attempt #{attempt}"
#       end
#     end
#
#     # Delete the document from Solr, retrying if an error occurs.
#     # See https://github.com/ooyala/retries for info on with_retries.
#     # @param [String] id the id of the Solr document to be deleted
#     def delete(id)
#       handler = Proc.new do |exception, attempt_cnt, total_delay|
#         @logger.debug "#{exception.inspect} on Solr delete attempt #{attempt_cnt} for #{id}"
#         if exception.kind_of?(RSolr::Error::Http)
#           # Note there are extra shenanigans b/c RSolr hijacks the Solr error to return RSolr Error
#           fail ActiveTriples::SearchError.new("error deleting doc #{id} from Solr: #{exception.message}", exception.response[:status], exception.response[:body])
#         elsif exception.kind_of?(StandardError)
#           fail ActiveTriples::SearchError.new("error deleting doc #{id} from Solr: #{exception.message}")
#         end
#       end
#
#       with_retries(:handler => handler,
#                    :max_tries => @max_retries,
#                    :base_sleep_seconds => @base_sleep_seconds,
#                    :max_sleep_seconds => @max_sleep_seconds) do |attempt|
#         @logger.debug "Solr delete attempt #{attempt} for #{id}"
#         #  RSolr throws RSolr::Error::Http for any Solr response without status 200 or 302
#         @rsolr_client.delete_by_id(id)
#         @rsolr_client.commit
#         @logger.info "Successfully deleted #{id} from Solr"
#       end
#     end
#
#   end
# end