require 'spec_helper'

describe ActiveTriples::Solrizer::ProfileIndexingService do

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
      property :bookEdition,  :predicate => RDF::SCHEMA.bookEdition                                                  # test non-indexed property
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

      it "should produce object profile holding serialization of the resource" do
        expected_object_profile = "{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[\"Test description of resource.\"],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[11],\"clip_number\":[20],\"price\":[13.49],\"awards\":[\"Darwin Award\",\"Head in the Sand Award\",\"Selective Hearing Award\"],\"bookEdition\":[\"Ed. 2\"]}"
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(subject).export ).to eq expected_object_profile
      end
    end

    context "when only some properties have values" do
      before do
        subject.title        = 'Test Title'
        subject.borrower_uri = 'http://www.example.org/person1'
        subject.clip_number  = 20
        subject.bookEdition  = 'Ed. 2'
      end

      it "should produce object profile holding serialization of the resource" do
        expected_object_profile = "{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[],\"clip_number\":[20],\"price\":[],\"awards\":[],\"bookEdition\":[\"Ed. 2\"]}"
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(subject).export ).to eq expected_object_profile
      end
    end
  end

  describe "#import" do
    context "when all properties have values" do

      let (:obj_profile) { "{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[\"Test description of resource.\"],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[11],\"clip_number\":[20],\"price\":[13.49],\"awards\":[\"Darwin Award\",\"Head in the Sand Award\",\"Selective Hearing Award\"],\"bookEdition\":[\"Ed. 2\"]}" }

      it "should deserialize resource from object profile" do
        filled_resource = ActiveTriples::Solrizer::ProfileIndexingService.new(subject).import( obj_profile )
        expect( filled_resource.id ).to           eq 'http://www.example.org/dr1'
        expect( filled_resource.title ).to        eq ['Test Title']
        expect( filled_resource.description ).to  eq ['Test description of resource.']
        expect( filled_resource.borrower_uri ).to eq ['http://www.example.org/person1']
        expect( filled_resource.answer_count ).to eq [11]
        expect( filled_resource.clip_number ).to  eq [20]
        expect( filled_resource.price ).to        eq [13.49]
        expect( filled_resource.awards ).to       eq ['Darwin Award','Head in the Sand Award','Selective Hearing Award']
        expect( filled_resource.bookEdition ).to  eq ['Ed. 2']
      end
    end

    context "when only some properties have values" do

      let (:obj_profile) { "{\"id\":\"http://www.example.org/dr1\",\"title\":[\"Test Title\"],\"description\":[],\"borrower_uri\":[\"http://www.example.org/person1\"],\"answer_count\":[],\"clip_number\":[20],\"price\":[],\"awards\":[],\"bookEdition\":[\"Ed. 2\"]}" }

      it "should deserialize resource from object profile" do
        filled_resource = ActiveTriples::Solrizer::ProfileIndexingService.new(subject).import( obj_profile )
        expect( filled_resource.id ).to           eq 'http://www.example.org/dr1'
        expect( filled_resource.title ).to        eq ['Test Title']
        expect( filled_resource.description ).to  eq []
        expect( filled_resource.borrower_uri ).to eq ['http://www.example.org/person1']
        expect( filled_resource.answer_count ).to eq []
        expect( filled_resource.clip_number ).to  eq [20]
        expect( filled_resource.price ).to        eq []
        expect( filled_resource.awards ).to       eq []
        expect( filled_resource.bookEdition ).to  eq ['Ed. 2']
      end
    end
  end
end
