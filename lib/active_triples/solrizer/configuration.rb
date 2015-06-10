module ActiveTriples::Solrizer
  class Configuration

    attr_reader :solr_uri
    attr_reader :read_timeout
    attr_reader :open_timeout
    attr_reader :max_solr_retries
    attr_reader :base_sleep_seconds
    attr_reader :max_sleep_seconds


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

    def self.default_max_solr_retries
      @default_max_solr_retries = 5
    end
    private_class_method :default_max_solr_retries

    def self.default_base_sleep_seconds
      @default_base_sleep_seconds = 1
    end
    private_class_method :default_base_sleep_seconds

    def self.default_max_sleep_seconds
      @default_max_sleep_seconds = 5
    end
    private_class_method :default_max_sleep_seconds

    def initialize
      @solr_uri           = self.class.send(:default_solr_uri)
      @read_timeout   = self.class.send(:default_read_timeout)
      @open_timeout   = self.class.send(:default_open_timeout)
      @max_solr_retries   = self.class.send(:default_max_solr_retries)
      @base_sleep_seconds = self.class.send(:default_base_sleep_seconds)
      @max_sleep_seconds  = self.class.send(:default_max_sleep_seconds)
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

    def max_solr_retries=(new_max_solr_retries)
      @max_solr_retries = new_max_solr_retries
    end

    def reset_max_solr_retries
      @max_solr_retries = self.class.send(:default_max_solr_retries)
    end

    def base_sleep_seconds=(new_base_sleep_seconds)
      @base_sleep_seconds = new_base_sleep_seconds
    end

    def reset_base_sleep_seconds
      @base_sleep_seconds = self.class.send(:default_base_sleep_seconds)
    end

    def max_sleep_seconds=(new_max_sleep_seconds)
      @max_sleep_seconds = new_max_sleep_seconds
    end

    def reset_max_sleep_seconds
      @max_sleep_seconds = self.class.send(:default_max_sleep_seconds)
    end
  end
end
