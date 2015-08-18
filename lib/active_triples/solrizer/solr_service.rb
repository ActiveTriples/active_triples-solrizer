require 'rsolr'
require 'deprecation'

module ActiveTriples::Solrizer
  class SolrService
    # NOTE: Copied from ActiveFedora::SolrService

    extend Deprecation

    attr_reader :conn

    def initialize(host, args)
      host = ActiveTriples::Solrizer.configuration.solr_uri unless host
      args = {read_timeout: ActiveTriples::Solrizer.configuration.read_timeout,
              open_timeout: ActiveTriples::Solrizer.configuration.open_timeout}.merge(args.dup)
      args.merge!(url: host)
      @conn = RSolr.connect args
    end

    class << self
      def register(host=nil, args={})
        Thread.current[:solr_service] = new(host, args)
      end

      def reset!
        Thread.current[:solr_service] = nil
      end

      def instance
        # Register Solr

        unless Thread.current[:solr_service]
          register(ActiveTriples::Solrizer.configuration.solr_uri)
        end

        raise SolrNotInitialized unless Thread.current[:solr_service]
        Thread.current[:solr_service]
      end

      def query(query, args={})
        raw = args.delete(:raw)
        args = args.merge(:q=>query, :qt=>'standard')
        result = SolrService.instance.conn.get('select', :params=>args)
        return result if raw
        result['response']['docs']
      end

      def delete(id)
        SolrService.instance.conn.delete_by_id(id, params: {'softCommit' => true})
      end

      # Get the count of records that match the query
      # @param [String] query a solr query
      # @param [Hash] args arguments to pass through to `args' param of SolrService.query (note that :rows will be overwritten to 0)
      # @return [Integer] number of records matching
      def count(query, args={})
        args = args.merge(:raw=>true, :rows=>0)
        SolrService.query(query, args)['response']['numFound'].to_i
      end

      # @param [Hash] doc the document to index
      # @param [Hash] params
      #   :commit => commits immediately
      #   :softCommit => commit to memory, but don't flush to disk
      def add(doc, params = {})
        SolrService.instance.conn.add(doc, params: params)
      end

      def commit
        SolrService.instance.conn.commit
      end

    end
  end #SolrService
  class SolrNotInitialized < StandardError;end
end #ActiveTriples::Solrizer
