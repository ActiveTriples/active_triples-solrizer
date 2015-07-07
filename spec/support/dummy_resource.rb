RSpec.shared_context "shared dummy resource class", :a => :b do
  before do
    class DummyResourceShort < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,        :predicate => RDF::SCHEMA.title          do |index|
        index.data_type = :text
        index.as :indexed, :sortable  # test tokenized text that also has sort field
      end
      property :description_si,  :predicate => RDF::SCHEMA.description do |index|
        index.data_type = :text
        index.as :stored, :indexed
      end
      property :borrower_uri_i, :predicate => RDF::SCHEMA.borrower     do |index|
        index.data_type = :string
        index.as :indexed
      end
      property :clip_number_simr, :predicate => RDF::SCHEMA.clipNumber do |index|
        index.data_type = :integer
        index.as :stored, :indexed, :multiValued, :range
      end
      property :price_s,        :predicate => RDF::SCHEMA.price        do |index|
        index.data_type = :float
        index.as :stored
      end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    #  :coordinate  - used to index the lat and long components for the "location"
    #  :location
    #  :guess       - allow guessing of the type based on the type of the property value

    class DummyResourceIndexed < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :indexed
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :indexed
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :indexed
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :indexed
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :indexed
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :indexed
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :indexed
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :indexed
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :indexed
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :indexed
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceStored < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :stored
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :stored
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :stored
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :stored
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :stored
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :stored
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :stored
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :stored
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :stored
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :stored
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceStoredIndexed < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :stored, :indexed
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :stored, :indexed
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :stored, :indexed
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :stored, :indexed
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :stored, :indexed
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :stored, :indexed
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :stored, :indexed
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :stored, :indexed
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :stored, :indexed
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :stored, :indexed
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceIndexedMulti < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :indexed, :multiValued
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :indexed, :multiValued
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :indexed, :multiValued
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :indexed, :multiValued
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :indexed, :multiValued
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :indexed, :multiValued
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :indexed, :multiValued
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :indexed, :multiValued
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :indexed, :multiValued
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :indexed, :multiValued
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceStoredMulti < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :stored, :multiValued, :multiValued
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :stored, :multiValued
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :stored, :multiValued
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :stored, :multiValued
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :stored, :multiValued
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :stored, :multiValued
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :stored, :multiValued
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :stored, :multiValued
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :stored, :multiValued
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :stored, :multiValued
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceStoredIndexedMulti < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :stored, :indexed, :multiValued
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :stored, :indexed, :multiValued
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :stored, :indexed, :multiValued
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :stored, :indexed, :multiValued
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :stored, :indexed, :multiValued
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :stored, :indexed, :multiValued
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :stored, :indexed, :multiValued
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :stored, :indexed, :multiValued
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :stored, :indexed, :multiValued
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :stored, :indexed, :multiValued
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceIndexedRange < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :indexed, :range
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :indexed, :range
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :indexed, :range
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :indexed, :range
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :indexed, :range
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :indexed, :range
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :indexed, :range
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :indexed, :range
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :indexed, :range
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :indexed, :range
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceIndexedSort < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :indexed, :sortable
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :indexed, :sortable
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :indexed, :sortable
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :indexed, :sortable
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :indexed, :sortable
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :indexed, :sortable
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :indexed, :sortable
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :indexed, :sortable
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :indexed, :sortable
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :indexed, :sortable
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceIndexedVector < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :text_en
        index.as :indexed, :vectored
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :text
        index.as :indexed, :vectored
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :string
        index.as :indexed, :vectored
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :integer
        index.as :indexed, :vectored
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :long
        index.as :indexed, :vectored
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :float
        index.as :indexed, :vectored
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :double
        index.as :indexed, :vectored
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :date
        index.as :indexed, :vectored
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :boolean
        index.as :indexed, :vectored
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :location
      #   index.as :indexed, :vectored
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    class DummyResourceIndexedGuess < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,          :predicate => RDF::SCHEMA.title         do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :description,    :predicate => RDF::SCHEMA.description   do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :borrower_uri,   :predicate => RDF::SCHEMA.borrower      do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :clip_number,    :predicate => RDF::SCHEMA.clipNumber    do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :answer_count,   :predicate => RDF::SCHEMA.answerCount   do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :price,          :predicate => RDF::SCHEMA.price         do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :max_price,      :predicate => RDF::SCHEMA.maxPrice      do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :modified_time,  :predicate => RDF::SCHEMA.modifiedTime  do |index|
        index.data_type = :guess
        index.as :indexed
      end
      property :is_proprietary, :predicate => RDF::SCHEMA.isProprietary do |index|
        index.data_type = :guess
        index.as :indexed
      end
      # property :latitude, :predicate => RDF::SCHEMA.latitude do |index|
      #   index.data_type = :guess
      #   index.as :indexed
      # end
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition    # test non-indexed property
    end

    ActiveTriples::Repositories.add_repository :default, RDF::Repository.new
  end

  after do
    if Object
      Object.send(:remove_const, "DummyResourceShort")
      Object.send(:remove_const, "DummyResourceIndexed")
      Object.send(:remove_const, "DummyResourceStored")
      Object.send(:remove_const, "DummyResourceStoredIndexed")
      Object.send(:remove_const, "DummyResourceIndexedMulti")
      Object.send(:remove_const, "DummyResourceStoredMulti")
      Object.send(:remove_const, "DummyResourceStoredIndexedMulti")
      Object.send(:remove_const, "DummyResourceIndexedRange")
      Object.send(:remove_const, "DummyResourceIndexedSort")
      Object.send(:remove_const, "DummyResourceIndexedVector")
      Object.send(:remove_const, "DummyResourceIndexedGuess")
    end
    ActiveTriples::Repositories.clear_repositories!
  end

# ===================

  let (:dr_short_all_values) do
    dr = DummyResourceShort.new('http://www.example.org/dr1')
    dr.title                = 'Test Title'
    dr.description_si       = 'Test text description stored and indexed.'
    dr.borrower_uri_i       = 'http://example.org/i/b2'
    dr.clip_number_simr     = [7,8,9,10]
    dr.price_s              = 789.01
    dr.bookEdition          = 'Ed. 2'
    dr
  end

  let (:expected_object_profile_short_all_values) do
    '{"id":"http://www.example.org/dr1",'\
     '"title":["Test Title"],'\
     '"description_si":["Test text description stored and indexed."],'\
     '"borrower_uri_i":["http://example.org/i/b2"],'\
     '"clip_number_simr":[7,8,9,10],'\
     '"price_s":[789.01],'\
     '"bookEdition":["Ed. 2"]}'
  end

  let (:expected_solr_properties_short_all_values) do
    {
        :title_ti=>"Test Title",
        :title_ssort=>"Test Title",
        :description_si_tsi=>"Test text description stored and indexed.",
        :borrower_uri_i_si=>"http://example.org/i/b2",
        :clip_number_simr_itsim=>[7,8,9,10],
        :price_s_fs=>789.01
    }
  end

  let (:expected_solr_doc_short_all_values) do
    {
      :id=>"http://www.example.org/dr1",
      :at_model_ssi=>"DummyResourceShort",
      :object_profile_ss=>expected_object_profile_short_all_values,
    }.merge(expected_solr_properties_short_all_values)
  end

  let (:dr_short_partial_values) do
    dr = DummyResourceShort.new('http://www.example.org/dr1')
    dr.title                = 'Test Title'
    dr.description_si       = 'Test text description stored and indexed.'
    dr.price_s              = 789.01
    dr.bookEdition          = 'Ed. 2'
    dr
  end

  let (:expected_object_profile_short_partial_values) do
    '{"id":"http://www.example.org/dr1",'\
     '"title":["Test Title"],'\
     '"description_si":["Test text description stored and indexed."],'\
     '"borrower_uri_i":[],'\
     '"clip_number_simr":[],'\
     '"price_s":[789.01],'\
     '"bookEdition":["Ed. 2"]}'
  end

  let (:expected_solr_properties_short_partial_values) do
    {
        :title_ti=>"Test Title",
        :title_ssort=>"Test Title",
        :description_si_tsi=>"Test text description stored and indexed.",
        :price_s_fs=>789.01
    }
  end

  let (:expected_solr_doc_short_partial_values) do
    {
      :id=>"http://www.example.org/dr1",
      :at_model_ssi=>"DummyResourceShort",
      :object_profile_ss=>expected_object_profile_short_partial_values,
    }.merge(expected_solr_properties_short_partial_values)
  end

# ===================

  let (:dr_indexed) do
    dr = DummyResourceIndexed.new('http://www.example.org/dr_i')
    dr.title          = 'Test Title'
    dr.description    = 'Test text description indexed.'
    dr.borrower_uri   = 'http://example.org/b_i'
    dr.clip_number    = 1
    dr.answer_count   = 12345678901234567891
    dr.price          = 123.41
    dr.max_price      = 12345678901234567.81
    dr.modified_time  = '1995-12-31T23:59:51Z'
    dr.is_proprietary = true
    # dr.latitude       =
    dr.bookEdition    = 'Ed. 1'
    dr
  end

  let (:expected_object_profile_indexed) do
    '{"id":"http://www.example.org/dr_i",'\
   '"title":["Test Title"],'\
   '"description":["Test text description indexed."],'\
   '"borrower_uri":["http://example.org/b_i"],'\
   '"clip_number":[1],'\
   '"answer_count":[12345678901234567891],'\
   '"price":[123.41],'\
   '"max_price":[1.2345678901234568e+16],'\
   '"modified_time":["1995-12-31T23:59:51Z"],'\
   '"is_proprietary":[true],'\
   '"bookEdition":["Ed. 1"]}'
  end

  let (:expected_solr_properties_indexed) do
    {
        :title_tei=>"Test Title",
        :description_ti=>"Test text description indexed.",
        :borrower_uri_si=>"http://example.org/b_i",
        :clip_number_ii=>1,
        :answer_count_li=>12345678901234567891,
        :price_fi=>123.41,
        :max_price_dbi=>12345678901234567.81,
        :modified_time_dti=>"1995-12-31T23:59:51Z",
        :is_proprietary_bi=>true
    }
  end

  let (:expected_solr_doc_indexed) do
    {
      :id=>"http://www.example.org/dr_i",
      :at_model_ssi=>"DummyResourceIndexed",
      :object_profile_ss=>expected_object_profile_indexed,
    }.merge(expected_solr_properties_indexed)
  end

# ===================

  let (:dr_stored) do
    dr = DummyResourceStored.new('http://www.example.org/dr_s')
    dr.title          = 'Test Title'
    dr.description    = 'Test text description stored.'
    dr.borrower_uri   = 'http://example.org/b_s'
    dr.clip_number    = 2
    dr.answer_count   = 12345678901234567892
    dr.price          = 123.42
    dr.max_price      = 12345678901234567.82
    dr.modified_time  = '1995-12-31T23:59:52Z'
    dr.is_proprietary = false
    # dr.latitude       =
    dr.bookEdition    = 'Ed. 2'
    dr
  end

  let (:expected_object_profile_stored) do
    '{"id":"http://www.example.org/dr_s",'\
   '"title":["Test Title"],'\
   '"description":["Test text description stored."],'\
   '"borrower_uri":["http://example.org/b_s"],'\
   '"clip_number":[2],'\
   '"answer_count":[12345678901234567892],'\
   '"price":[123.42],'\
   '"max_price":[1.2345678901234568e+16],'\
   '"modified_time":["1995-12-31T23:59:52Z"],'\
   '"is_proprietary":[false],'\
   '"bookEdition":["Ed. 2"]}'
  end

  let (:expected_solr_properties_stored) do
    {
        :title_tes=>"Test Title",
        :description_ts=>"Test text description stored.",
        :borrower_uri_ss=>"http://example.org/b_s",
        :clip_number_is=>2,
        :answer_count_ls=>12345678901234567892,
        :price_fs=>123.42,
        :max_price_dbs=>12345678901234567.82,
        :modified_time_dts=>"1995-12-31T23:59:52Z",
        :is_proprietary_bs=>false
    }
  end

  let (:expected_solr_doc_stored) do
    {
        :id=>"http://www.example.org/dr_s",
        :at_model_ssi=>"DummyResourceStored",
        :object_profile_ss=>expected_object_profile_stored,
    }.merge(expected_solr_properties_stored)
  end

# ===================

  let (:dr_stored_indexed) do
    dr = DummyResourceStoredIndexed.new('http://www.example.org/dr_si')
    dr.title          = 'Test Title'
    dr.description    = 'Test text description stored and indexed.'
    dr.borrower_uri   = 'http://example.org/b_si'
    dr.clip_number    = 3
    dr.answer_count   = 12345678901234567893
    dr.price          = 123.43
    dr.max_price      = 12345678901234567.83
    dr.modified_time  = '1995-12-31T23:59:53Z'
    dr.is_proprietary = false
    # dr.latitude       =
    dr.bookEdition    = 'Ed. 3'
    dr
  end

  let (:expected_object_profile_stored_indexed) do
    '{"id":"http://www.example.org/dr_si",'\
   '"title":["Test Title"],'\
   '"description":["Test text description stored and indexed."],'\
   '"borrower_uri":["http://example.org/b_si"],'\
   '"clip_number":[3],'\
   '"answer_count":[12345678901234567893],'\
   '"price":[123.43],'\
   '"max_price":[1.2345678901234568e+16],'\
   '"modified_time":["1995-12-31T23:59:53Z"],'\
   '"is_proprietary":[false],'\
   '"bookEdition":["Ed. 3"]}'
  end

  let (:expected_solr_properties_stored_indexed) do
    {
        :title_tesi=>"Test Title",
        :description_tsi=>"Test text description stored and indexed.",
        :borrower_uri_ssi=>"http://example.org/b_si",
        :clip_number_isi=>3,
        :answer_count_lsi=>12345678901234567893,
        :price_fsi=>123.43,
        :max_price_dbsi=>12345678901234567.83,
        :modified_time_dtsi=>"1995-12-31T23:59:53Z",
        :is_proprietary_bsi=>false
    }
  end

  let (:expected_solr_doc_stored_indexed) do
    {
        :id=>"http://www.example.org/dr_si",
        :at_model_ssi=>"DummyResourceStoredIndexed",
        :object_profile_ss=>expected_object_profile_stored_indexed,
    }.merge(expected_solr_properties_stored_indexed)
  end

# ===================
# ===================

  let (:dr_indexed_multi) do
    dr = DummyResourceIndexedMulti.new('http://www.example.org/dr_im')
    dr.title          = ['Test Title','Title 2']
    dr.description    = ['Test text description indexed and multi values.','Desc 2','Desc 3']
    dr.borrower_uri   = ['http://example.org/b_im','http://example.org/b_im2']
    dr.clip_number    = [1,2,3,4]
    dr.answer_count   = [12345678901234567891,22345678901234567891]
    dr.price          = [123.41,223.41]
    dr.max_price      = [12345678901234567.81,22345678901234567.81]
    dr.modified_time  = ['1995-12-31T23:59:51Z','2015-12-31T23:59:51Z']
    dr.is_proprietary = [true,false]
    # dr.latitude       =
    dr.bookEdition    = ['Ed. 1','Ed. 1a']
    dr
  end

  let (:expected_object_profile_indexed_multi) do
    '{"id":"http://www.example.org/dr_im",'\
   '"title":["Test Title","Title 2"],'\
   '"description":["Test text description indexed and multi values.","Desc 2","Desc 3"],'\
   '"borrower_uri":["http://example.org/b_im","http://example.org/b_im2"],'\
   '"clip_number":[1,2,3,4],'\
   '"answer_count":[12345678901234567891,22345678901234567891],'\
   '"price":[123.41,223.41],'\
   '"max_price":[1.2345678901234568e+16,2.234567890123457e+16],'\
   '"modified_time":["1995-12-31T23:59:51Z","2015-12-31T23:59:51Z"],'\
   '"is_proprietary":[true,false],'\
   '"bookEdition":["Ed. 1","Ed. 1a"]}'
  end

  let (:expected_solr_properties_indexed_multi) do
    {
        :title_teim=>["Test Title","Title 2"],
        :description_tim=>["Test text description indexed and multi values.","Desc 2","Desc 3"],
        :borrower_uri_sim=>["http://example.org/b_im","http://example.org/b_im2"],
        :clip_number_iim=>[1,2,3,4],
        :answer_count_lim=>[12345678901234567891,22345678901234567891],
        :price_fim=>[123.41,223.41],
        :max_price_dbim=>[12345678901234567.81,22345678901234567.81],
        :modified_time_dtim=>["1995-12-31T23:59:51Z","2015-12-31T23:59:51Z"],
        :is_proprietary_bi=>true    # multi-value not allowed for boolean; use first value
    }
  end

  let (:expected_solr_doc_indexed_multi) do
    {
        :id=>"http://www.example.org/dr_im",
        :at_model_ssi=>"DummyResourceIndexedMulti",
        :object_profile_ss=>expected_object_profile_indexed_multi,
    }.merge(expected_solr_properties_indexed_multi)
  end

# ===================

  let (:dr_stored_multi) do
    dr = DummyResourceStoredMulti.new('http://www.example.org/dr_sm')
    dr.title          = ['Test Title','Title 2']
    dr.description    = ['Test text description stored and multi values.','Desc 2','Desc 3']
    dr.borrower_uri   = ['http://example.org/b_sm','http://example.org/b_sm2']
    dr.clip_number    = [2,3,4,5]
    dr.answer_count   = [12345678901234567892,22345678901234567892]
    dr.price          = [123.42,223.42]
    dr.max_price      = [12345678901234567.82,22345678901234567.82]
    dr.modified_time  = ['1995-12-31T23:59:52Z','2015-12-31T23:59:52Z']
    dr.is_proprietary = [false,true]
    # dr.latitude       =
    dr.bookEdition    = ['Ed. 2','Ed. 2a']
    dr
  end

  let (:expected_object_profile_stored_multi) do
    '{"id":"http://www.example.org/dr_sm",'\
   '"title":["Test Title","Title 2"],'\
   '"description":["Test text description stored and multi values.","Desc 2","Desc 3"],'\
   '"borrower_uri":["http://example.org/b_sm","http://example.org/b_sm2"],'\
   '"clip_number":[2,3,4,5],'\
   '"answer_count":[12345678901234567892,22345678901234567892],'\
   '"price":[123.42,223.42],'\
   '"max_price":[1.2345678901234568e+16,2.234567890123457e+16],'\
   '"modified_time":["1995-12-31T23:59:52Z","2015-12-31T23:59:52Z"],'\
   '"is_proprietary":[false,true],'\
   '"bookEdition":["Ed. 2","Ed. 2a"]}'
  end

  let (:expected_solr_properties_stored_multi) do
    {
        :title_tesm=>["Test Title","Title 2"],
        :description_tsm=>["Test text description stored and multi values.","Desc 2","Desc 3"],
        :borrower_uri_ssm=>["http://example.org/b_sm","http://example.org/b_sm2"],
        :clip_number_ism=>[2,3,4,5],
        :answer_count_lsm=>[12345678901234567892,22345678901234567892],
        :price_fsm=>[123.42,223.42],
        :max_price_dbsm=>[12345678901234567.82,22345678901234567.82],
        :modified_time_dtsm=>["1995-12-31T23:59:52Z","2015-12-31T23:59:52Z"],
        :is_proprietary_bs=>false
    }
  end

  let (:expected_solr_doc_stored_multi) do
    {
        :id=>"http://www.example.org/dr_sm",
        :at_model_ssi=>"DummyResourceStoredMulti",
        :object_profile_ss=>expected_object_profile_stored_multi,
    }.merge(expected_solr_properties_stored_multi)
  end

# ===================

  let (:dr_stored_indexed_multi) do
    dr = DummyResourceStoredIndexedMulti.new('http://www.example.org/dr_sim')
    dr.title          = ['Test Title','Title 2']
    dr.description    = ['Test text description stored and indexed and multi values.','Desc 2','Desc 3']
    dr.borrower_uri   = ['http://example.org/b_sim','http://example.org/b_sim3']
    dr.clip_number    = [3,4,5,6]
    dr.answer_count   = [12345678901234567893,32345678901234567893]
    dr.price          = [123.43,323.43]
    dr.max_price      = [12345678901234567.83,32345678901234567.83]
    dr.modified_time  = ['1995-12-31T23:59:53Z','2015-12-31T23:59:53Z']
    dr.is_proprietary = [false,true]
    # dr.latitude       =
    dr.bookEdition    = ['Ed. 3','Ed. 3a']
    dr
  end

  let (:expected_object_profile_stored_indexed_multi) do
    '{"id":"http://www.example.org/dr_sim",'\
   '"title":["Test Title","Title 2"],'\
   '"description":["Test text description stored and indexed and multi values.","Desc 2","Desc 3"],'\
   '"borrower_uri":["http://example.org/b_sim","http://example.org/b_sim3"],'\
   '"clip_number":[3,4,5,6],'\
   '"answer_count":[12345678901234567893,32345678901234567893],'\
   '"price":[123.43,323.43],'\
   '"max_price":[1.2345678901234568e+16,3.234567890123457e+16],'\
   '"modified_time":["1995-12-31T23:59:53Z","2015-12-31T23:59:53Z"],'\
   '"is_proprietary":[false,true],'\
   '"bookEdition":["Ed. 3","Ed. 3a"]}'
  end

  let (:expected_solr_properties_stored_indexed_multi) do
    {
        :title_tesim=>["Test Title","Title 2"],
        :description_tsim=>["Test text description stored and indexed and multi values.","Desc 2","Desc 3"],
        :borrower_uri_ssim=>["http://example.org/b_sim","http://example.org/b_sim3"],
        :clip_number_isim=>[3,4,5,6],
        :answer_count_lsim=>[12345678901234567893,32345678901234567893],
        :price_fsim=>[123.43,323.43],
        :max_price_dbsim=>[12345678901234567.83,32345678901234567.83],
        :modified_time_dtsim=>["1995-12-31T23:59:53Z","2015-12-31T23:59:53Z"],
        :is_proprietary_bsi=>false
    }
  end

  let (:expected_solr_doc_stored_indexed_multi) do
    {
        :id=>"http://www.example.org/dr_sim",
        :at_model_ssi=>"DummyResourceStoredIndexedMulti",
        :object_profile_ss=>expected_object_profile_stored_indexed_multi,
    }.merge(expected_solr_properties_stored_indexed_multi)
  end

# ===================
# ===================

  let (:dr_indexed_range) do
    dr = DummyResourceIndexedRange.new('http://www.example.org/dr_ir')
    dr.title          = 'Test Title'
    dr.description    = 'Test text description indexed with range.'
    dr.borrower_uri   = 'http://example.org/b_ir'
    dr.clip_number    = 1
    dr.answer_count   = 12345678901234567891
    dr.price          = 123.41
    dr.max_price      = 12345678901234567.81
    dr.modified_time  = '1995-12-31T23:59:51Z'
    dr.is_proprietary = true
    # dr.latitude       =
    dr.bookEdition    = 'Ed. 1'
    dr
  end

  let (:expected_object_profile_indexed_range) do
    '{"id":"http://www.example.org/dr_ir",'\
   '"title":["Test Title"],'\
   '"description":["Test text description indexed with range."],'\
   '"borrower_uri":["http://example.org/b_ir"],'\
   '"clip_number":[1],'\
   '"answer_count":[12345678901234567891],'\
   '"price":[123.41],'\
   '"max_price":[1.2345678901234568e+16],'\
   '"modified_time":["1995-12-31T23:59:51Z"],'\
   '"is_proprietary":[true],'\
   '"bookEdition":["Ed. 1"]}'
  end

  let (:expected_solr_properties_indexed_range) do
    {
        :title_tei=>"Test Title",
        :description_ti=>"Test text description indexed with range.",
        :borrower_uri_si=>"http://example.org/b_ir",
        :clip_number_iti=>1,
        :answer_count_lti=>12345678901234567891,
        :price_fti=>123.41,
        :max_price_dbti=>12345678901234567.81,
        :modified_time_dtti=>"1995-12-31T23:59:51Z",
        :is_proprietary_bi=>true
    }
  end

  let (:expected_solr_doc_indexed_range) do
    {
        :id=>"http://www.example.org/dr_ir",
        :at_model_ssi=>"DummyResourceIndexedRange",
        :object_profile_ss=>expected_object_profile_indexed_range,
    }.merge(expected_solr_properties_indexed_range)
  end

# ===================

  let (:dr_indexed_sort) do
    dr = DummyResourceIndexedSort.new('http://www.example.org/dr_isort')
    dr.title          = 'Test Title'
    dr.description    = 'Test text description indexed and sortable.'
    dr.borrower_uri   = 'http://example.org/b_isort'
    dr.clip_number    = 1
    dr.answer_count   = 12345678901234567891
    dr.price          = 123.41
    dr.max_price      = 12345678901234567.81
    dr.modified_time  = '1995-12-31T23:59:51Z'
    dr.is_proprietary = true
    # dr.latitude       =
    dr.bookEdition    = 'Ed. 1'
    dr
  end

  let (:expected_object_profile_indexed_sort) do
    '{"id":"http://www.example.org/dr_isort",'\
   '"title":["Test Title"],'\
   '"description":["Test text description indexed and sortable."],'\
   '"borrower_uri":["http://example.org/b_isort"],'\
   '"clip_number":[1],'\
   '"answer_count":[12345678901234567891],'\
   '"price":[123.41],'\
   '"max_price":[1.2345678901234568e+16],'\
   '"modified_time":["1995-12-31T23:59:51Z"],'\
   '"is_proprietary":[true],'\
   '"bookEdition":["Ed. 1"]}'
  end

  let (:expected_solr_properties_indexed_sort) do
    {
        :title_tei=>"Test Title",
        :title_ssort=>"Test Title",
        :description_ti=>"Test text description indexed and sortable.",
        :description_ssort=>"Test text description indexed and sortable.",
        :borrower_uri_si=>"http://example.org/b_isort",
        :borrower_uri_ssort=>"http://example.org/b_isort",
        :clip_number_iti=>1,
        :answer_count_lti=>12345678901234567891,
        :price_fti=>123.41,
        :max_price_dbti=>12345678901234567.81,
        :modified_time_dtti=>"1995-12-31T23:59:51Z",
        :is_proprietary_bi=>true
    }
  end

  let (:expected_solr_doc_indexed_sort) do
    {
        :id=>"http://www.example.org/dr_isort",
        :at_model_ssi=>"DummyResourceIndexedSort",
        :object_profile_ss=>expected_object_profile_indexed_sort,
    }.merge(expected_solr_properties_indexed_sort)
  end

# ===================

  let (:dr_indexed_vector) do
    dr = DummyResourceIndexedVector.new('http://www.example.org/dr_iv')
    dr.title          = 'Test Title'
    dr.description    = 'Test text description indexed and vectored.'
    dr.borrower_uri   = 'http://example.org/b_iv'
    dr.clip_number    = 1
    dr.answer_count   = 12345678901234567891
    dr.price          = 123.41
    dr.max_price      = 12345678901234567.81
    dr.modified_time  = '1995-12-31T23:59:51Z'
    dr.is_proprietary = true
    # dr.latitude       =
    dr.bookEdition    = 'Ed. 1'
    dr
  end

  let (:expected_object_profile_indexed_vector) do
    '{"id":"http://www.example.org/dr_iv",'\
   '"title":["Test Title"],'\
   '"description":["Test text description indexed and vectored."],'\
   '"borrower_uri":["http://example.org/b_iv"],'\
   '"clip_number":[1],'\
   '"answer_count":[12345678901234567891],'\
   '"price":[123.41],'\
   '"max_price":[1.2345678901234568e+16],'\
   '"modified_time":["1995-12-31T23:59:51Z"],'\
   '"is_proprietary":[true],'\
   '"bookEdition":["Ed. 1"]}'
  end

  let (:expected_solr_properties_indexed_vector) do
    {
        :title_teiv=>"Test Title",
        :description_tiv=>"Test text description indexed and vectored.",
        :borrower_uri_si=>"http://example.org/b_iv",
        :clip_number_ii=>1,
        :answer_count_li=>12345678901234567891,
        :price_fi=>123.41,
        :max_price_dbi=>12345678901234567.81,
        :modified_time_dti=>"1995-12-31T23:59:51Z",
        :is_proprietary_bi=>true
    }
  end

  let (:expected_solr_doc_indexed_vector) do
    {
        :id=>"http://www.example.org/dr_iv",
        :at_model_ssi=>"DummyResourceIndexedVector",
        :object_profile_ss=>expected_object_profile_indexed_vector,
    }.merge(expected_solr_properties_indexed_vector)
  end

# ===================

  let (:dr_indexed_guess) do
    dr = DummyResourceIndexedGuess.new('http://www.example.org/dr_ig')
    dr.title          = 'Test Title'
    dr.description    = 'Test text description indexed and guess type.'
    dr.borrower_uri   = 'http://example.org/b_ig'
    dr.clip_number    = 1
    dr.answer_count   = 12345678901234567891
    dr.price          = 123.41
    dr.max_price      = 12345678901234567.81
    dr.modified_time  = '1995-12-31T23:59:51Z'
    dr.is_proprietary = true
    # dr.latitude       =
    dr.bookEdition    = 'Ed. 1'
    dr
  end

  let (:expected_object_profile_indexed_guess) do
    '{"id":"http://www.example.org/dr_ig",'\
   '"title":["Test Title"],'\
   '"description":["Test text description indexed and guess type."],'\
   '"borrower_uri":["http://example.org/b_ig"],'\
   '"clip_number":[1],'\
   '"answer_count":[12345678901234567891],'\
   '"price":[123.41],'\
   '"max_price":[1.2345678901234568e+16],'\
   '"modified_time":["1995-12-31T23:59:51Z"],'\
   '"is_proprietary":[true],'\
   '"bookEdition":["Ed. 1"]}'
  end

  let (:expected_solr_properties_indexed_guess) do
    {
        :title_ti=>"Test Title",
        :description_ti=>"Test text description indexed and guess type.",
        :borrower_uri_ti=>"http://example.org/b_ig",
        :clip_number_ii=>1,
        :answer_count_li=>12345678901234567891,
        :price_fi=>123.41,
        :max_price_fi=>12345678901234567.81,
        :modified_time_dti=>"1995-12-31T23:59:51Z",
        :is_proprietary_bi=>true
    }
  end

  let (:expected_solr_doc_indexed_guess) do
    {
        :id=>"http://www.example.org/dr_ig",
        :at_model_ssi=>"DummyResourceIndexedGuess",
        :object_profile_ss=>expected_object_profile_indexed_guess,
    }.merge(expected_solr_properties_indexed_guess)
  end

end
