require 'active_triples/solrizer/version'
require 'active_support'
require 'solrizer'

SOLR_DOCUMENT_ID = Solrizer.default_field_mapper.id_field unless defined?(SOLR_DOCUMENT_ID)

module ActiveTriples
  module Solrizer
    extend ActiveSupport::Autoload
    eager_autoload do
      autoload :Configuration
      autoload :IndexingService
      autoload :ProfileIndexingService
      autoload :PropertiesIndexingService
      autoload :SolrInstanceLoader
      autoload :SolrService
      autoload :SolrQueryBuilder
      autoload :QueryResultBuilder
    end

    class << self
      # Convenience method for getting class constant based on a string
      # @example
      #   ActiveFedora.class_from_string("Om")
      #   => Om
      #   ActiveFedora.class_from_string("ActiveFedora::RdfNode::TermProxy")
      #   => ActiveFedora::RdfNode::TermProxy
      # @example Search within ActiveFedora::RdfNode for a class called "TermProxy"
      #   ActiveFedora.class_from_string("TermProxy", ActiveFedora::RdfNode)
      #   => ActiveFedora::RdfNode::TermProxy
      def class_from_string(class_name, container_class=Kernel)
        container_class = container_class.name if container_class.is_a? Module
        container_parts = container_class.split('::')
        (container_parts + class_name.split('::')).flatten.inject(Kernel) do |mod, class_name|
          if mod == Kernel
            Object.const_get(class_name)
          elsif mod.const_defined? class_name.to_sym
            mod.const_get(class_name)
          else
            container_parts.pop
            class_from_string(class_name, container_parts.join('::'))
          end
        end
      end
    end

    # Methods for configuring the GEM
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end

  end
end

