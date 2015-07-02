require 'spec_helper'

describe ActiveTriples::Solrizer::SolrService do

  describe "#generate_solr_document" do

    subject {DummyResource.new('http://www.example.org/dr1')}

    before do
      class DummyResource < ActiveTriples::Resource
        configure :type => RDF::URI('http://example.org/SomeClass')
        property :title,        :predicate => RDF::SCHEMA.title,       :data_type => :text,   :behaviors => [:indexed, :sortable]  # test tokenized text & sortable
        property :description,  :predicate => RDF::SCHEMA.description, :data_type => :text,   :behaviors => [:indexed]             # test tokenized text, but not sortable
        property :borrower_uri, :predicate => RDF::SCHEMA.borrower,    :data_type => :string, :behaviors => [:indexed]             # test non-tokenized text
        property :answer_count, :predicate => RDF::SCHEMA.answerCount, :data_type => :int,    :behaviors => [:indexed]             # test int
        property :clip_number,  :predicate => RDF::SCHEMA.clipNumber,  :data_type => :int,    :behaviors => [:indexed, :range]     # test int range
        property :price,        :predicate => RDF::SCHEMA.price,       :data_type => :float,  :behaviors => [:indexed]             # test float
        property :awards,       :predicate => RDF::SCHEMA.awards,      :data_type => :string, :behaviors => [:indexed, :multiple]  # test multiple values
        property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition                                                              # test non-indexed property
      end
      ActiveTriples::Repositories.add_repository :default, RDF::Repository.new
    end
    after do
      Object.send(:remove_const, "DummyResource") if Object
      ActiveTriples::Repositories.clear_repositories!
    end

    context "when all properties have values" do
      before do
        subject.title        = 'Test Title'
        subject.description  = 'Test description of resource.'
        subject.borrower_uri = 'http://www.example.org/person1'
        subject.answer_count = 11
        subject.clip_number  = 20
        subject.price        = 13.49
        subject.awards       = ['Darwin Award','Head in the Sand Award','Selective Hearing Award']
        subject.bookEdition  = 'Ed. 2'
      end

      it "should produce solr doc with all indexed properties" do
        expected_solr_doc = {:id=>"http://www.example.org/dr1",
                             :at_model_ssi=>"DummyResource",
                             :object_profile_ss=>"{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[\"Test description of resource.\"],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[11],\"clip_number\":[20],\"price\":[13.49],\"awards\":[\"Darwin Award\",\"Head in the Sand Award\",\"Selective Hearing Award\"],\"bookEdition\":[\"Ed. 2\"]}",
                             :title_ti=>"Test Title",
                             :title_sort_ss=>"Test Title",
                             :description_tsi=>"Test description of resource.",
                             :borrower_uri_ssi=>"http://www.example.org/person1",
                             :answer_count_isi=>11,
                             :clip_number_itsi=>20,
                             :price_fsi=>13.49,
                             :awards_ssim=>["Darwin Award", "Head in the Sand Award", "Selective Hearing Award"]}
        expect( ActiveTriples::Solrizer::IndexingService.new(subject).generate_solr_document ).to eq expected_solr_doc
      end

      it "should yield to block" do
        expected_solr_doc = {:id=>"http://www.example.org/dr1",
                             :at_model_ssi=>"DummyResource",
                             :object_profile_ss=>"{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[\"Test description of resource.\"],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[11],\"clip_number\":[20],\"price\":[13.49],\"awards\":[\"Darwin Award\",\"Head in the Sand Award\",\"Selective Hearing Award\"],\"bookEdition\":[\"Ed. 2\"]}",
                             :title_ti=>"Test Title",
                             :title_sort_ss=>"Test Title",
                             :description_tsi=>"Test description of resource.",
                             :borrower_uri_ssi=>"http://www.example.org/person1",
                             :answer_count_isi=>11,
                             :clip_number_itsi=>20,
                             :price_fsi=>13.49,
                             :awards_ssim=>["Darwin Award", "Head in the Sand Award", "Selective Hearing Award"],
                             :added_field_ssi=>"Caller's Field"}
        expect( ActiveTriples::Solrizer::IndexingService.new(subject).generate_solr_document { |solr_doc| solr_doc.merge!(:added_field_ssi => "Caller's Field") } ).to eq expected_solr_doc
      end
    end

    context "when only some properties have values" do
      before do
        subject.title        = 'Test Title'
        subject.borrower_uri = 'http://www.example.org/person1'
        subject.clip_number  = 20
        subject.bookEdition  = 'Ed. 2'
      end

      it "should produce solr doc with all indexed properties" do
        expected_solr_doc = {:id=>"http://www.example.org/dr1",
                             :at_model_ssi=>"DummyResource",
                             :object_profile_ss=>"{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[],\"clip_number\":[20],\"price\":[],\"awards\":[],\"bookEdition\":[\"Ed. 2\"]}",
                             :title_ti=>"Test Title",
                             :title_sort_ss=>"Test Title",
                             :borrower_uri_ssi=>"http://www.example.org/person1",
                             :clip_number_itsi=>20}
        expect( ActiveTriples::Solrizer::IndexingService.new(subject).generate_solr_document ).to eq expected_solr_doc
      end

      it "should yield to block" do
        expected_solr_doc = {:id=>"http://www.example.org/dr1",
                             :at_model_ssi=>"DummyResource",
                             :object_profile_ss=>"{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[],\"clip_number\":[20],\"price\":[],\"awards\":[],\"bookEdition\":[\"Ed. 2\"]}",
                             :title_ti=>"Test Title",
                             :title_sort_ss=>"Test Title",
                             :borrower_uri_ssi=>"http://www.example.org/person1",
                             :clip_number_itsi=>20,
                             :added_field_ssi=>"Caller's Field"}
        expect( ActiveTriples::Solrizer::IndexingService.new(subject).generate_solr_document { |solr_doc| solr_doc.merge!(:added_field_ssi => "Caller's Field") } ).to eq expected_solr_doc
      end
    end

  end
end
