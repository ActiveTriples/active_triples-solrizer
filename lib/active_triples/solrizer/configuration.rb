module ActiveTriples::Solrizer
  class Configuration

    attr_reader :solr_uri
    attr_reader :read_timeout
    attr_reader :open_timeout


    def self.default_solr_uri
      @default_solr_uri = "http://localhost:8983/solr/".freeze
    end
    private_class_method :default_solr_uri

    def self.default_read_timeout
      @default_read_timeout = 120
    end
    private_class_method :default_read_timeout

    def self.default_open_timeout
      @default_open_timeout = 120
    end
    private_class_method :default_open_timeout

    def initialize
      @solr_uri           = self.class.send(:default_solr_uri)
      @read_timeout   = self.class.send(:default_read_timeout)
      @open_timeout   = self.class.send(:default_open_timeout)
    end

    def solr_uri=(new_solr_uri)
      @solr_uri = new_solr_uri
    end

    def reset_solr_uri
      @solr_uri = self.class.send(:default_solr_uri)
    end

    def read_timeout=(new_read_timeout)
      @read_timeout = new_read_timeout
    end

    def reset_read_timeout
      @read_timeout = self.class.send(:default_read_timeout)
    end

    def open_timeout=(new_open_timeout)
      @open_timeout = new_open_timeout
    end

    def reset_open_timeout
      @open_timeout = self.class.send(:default_open_timeout)
    end
  end
end
