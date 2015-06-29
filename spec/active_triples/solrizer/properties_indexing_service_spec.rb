require 'spec_helper'

describe ActiveTriples::Solrizer::PropertiesIndexingService do

  before do
    class DummyResource < ActiveTriples::Resource
      configure :type => RDF::URI('http://example.org/SomeClass')
      property :title,        :predicate => RDF::SCHEMA.title,       :indexed => true, :tokenize => true, :sortable => true  # test tokenized text & sortable
      property :description,  :predicate => RDF::SCHEMA.description, :indexed => true, :tokenize => true                     # test tokenized text, but not sortable
      property :borrower_uri, :predicate => RDF::SCHEMA.borrower,    :indexed => true                     # test non-tokenized text
      property :answer_count, :predicate => RDF::SCHEMA.answerCount, :indexed => true                     # test int
      property :clip_number,  :predicate => RDF::SCHEMA.clipNumber,  :indexed => true, :range => true     # test int range
      property :price,        :predicate => RDF::SCHEMA.price,       :indexed => true                     # test float
      property :awards,       :predicate => RDF::SCHEMA.awards,      :indexed => true, :multiple => true  # test multiple values
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition                                       # test non-indexed property
    end
    ActiveTriples::Repositories.add_repository :default, RDF::Repository.new
  end
  after do
    Object.send(:remove_const, "DummyResource") if Object
    ActiveTriples::Repositories.clear_repositories!
  end

  subject {DummyResource.new('http://www.example.org/dr1')}

  describe "#export" do
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

      it "should produce solr fields holding values for indexed properties of the resource" do
        expected_solr_doc = {:title_ti=>"Test Title",
                             :title_sort_ss=>"Test Title",
                             :description_tsi=>"Test description of resource.",
                             :borrower_uri_ssi=>"http://www.example.org/person1",
                             :answer_count_isi=>11,
                             :clip_number_itsi=>20,
                             :price_fsi=>13.49,
                             :awards_ssim=>["Darwin Award", "Head in the Sand Award", "Selective Hearing Award"]}
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(subject).export ).to eq expected_solr_doc
      end
    end

    context "when only some properties have values" do
      before do
        subject.title        = 'Test Title'
        subject.borrower_uri = 'http://www.example.org/person1'
        subject.clip_number  = 20
        subject.bookEdition  = 'Ed. 2'
      end

      it "should produce solr fields holding values for indexed properties of the resource" do
        expected_solr_doc = {:title_ti=>"Test Title",
                             :title_sort_ss=>"Test Title",
                             :borrower_uri_ssi=>"http://www.example.org/person1",
                             :clip_number_itsi=>20}
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(subject).export ).to eq expected_solr_doc
      end
    end

  end
end
