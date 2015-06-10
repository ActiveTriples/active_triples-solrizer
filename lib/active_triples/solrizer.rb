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
      autoload :SolrService
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

