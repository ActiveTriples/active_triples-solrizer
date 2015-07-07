require 'spec_helper'
require 'support/dummy_resource.rb'

describe ActiveTriples::Solrizer::ProfileIndexingService do
  include_context "shared dummy resource class"

  describe "#export" do

    context "when small number of properties" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_short_all_values).export ).to eq expected_object_profile_short_all_values
      end

      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_short_partial_values).export ).to eq expected_object_profile_short_partial_values
      end
    end

    context "when all properties indexed" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_indexed).export ).to eq expected_object_profile_indexed
      end
    end

    context "when all properties stored" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_stored).export ).to eq expected_object_profile_stored
      end
    end

    context "when all properties stored and indexed" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_stored_indexed).export ).to eq expected_object_profile_stored_indexed
      end
    end

    context "when all properties indexed and multi-valued" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_indexed_multi).export ).to eq expected_object_profile_indexed_multi
      end
    end

    context "when all properties stored and multi-valued" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_stored_multi).export ).to eq expected_object_profile_stored_multi
      end
    end

    context "when all properties stored and indexed and multi-valued" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_stored_indexed_multi).export ).to eq expected_object_profile_stored_indexed_multi
      end
    end

    context "when all properties indexed and range" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_indexed_range).export ).to eq expected_object_profile_indexed_range
      end
    end

    context "when all properties indexed and sortable" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_indexed_sort).export ).to eq expected_object_profile_indexed_sort
      end
    end

    context "when all properties indexed and vectored" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_indexed_vector).export ).to eq expected_object_profile_indexed_vector
      end
    end

    context "when all properties indexed and guessing the type" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::ProfileIndexingService.new(dr_indexed_guess).export ).to eq expected_object_profile_indexed_guess
      end
    end
  end

  describe "#import" do
    context "when all properties have values" do
      it "should fill a resource with values by deserializing the object profile stored with the solr doc" do
        filled_resource = ActiveTriples::Solrizer::ProfileIndexingService.new(dr_short_all_values).import( expected_object_profile_short_all_values )
        expect( filled_resource.id ).to               eq 'http://www.example.org/dr1'
        expect( filled_resource.title ).to            eq ['Test Title']
        expect( filled_resource.description_si ).to   eq ['Test text description stored and indexed.']
        expect( filled_resource.borrower_uri_i ).to   eq ['http://example.org/i/b2']
        expect( filled_resource.clip_number_simr ).to eq [7,8,9,10]
        expect( filled_resource.price_s ).to          eq [789.01]
        expect( filled_resource.bookEdition ).to      eq ['Ed. 2']
      end
    end

    context "when some properties do not have values" do
      it "should fill a resource with values by deserializing the object profile stored with the solr doc" do
        filled_resource = ActiveTriples::Solrizer::ProfileIndexingService.new(dr_short_partial_values).import( expected_object_profile_short_partial_values )
        expect( filled_resource.id ).to               eq 'http://www.example.org/dr1'
        expect( filled_resource.title ).to            eq ['Test Title']
        expect( filled_resource.description_si ).to   eq ['Test text description stored and indexed.']
        expect( filled_resource.borrower_uri_i ).to   eq []
        expect( filled_resource.clip_number_simr ).to eq []
        expect( filled_resource.price_s ).to          eq [789.01]
        expect( filled_resource.bookEdition ).to      eq ['Ed. 2']
      end
    end

    context "when properties have multiple values and all types represented" do
      it "should fill a resource with values by deserializing the object profile stored with the solr doc" do
        filled_resource = ActiveTriples::Solrizer::ProfileIndexingService.new(dr_stored_indexed_multi).import( expected_object_profile_stored_indexed_multi )
        expect( filled_resource.id ).to              eq 'http://www.example.org/dr_sim'
        expect( filled_resource.title ).to           eq ['Test Title','Title 2']
        expect( filled_resource.description ).to     eq ['Test text description stored and indexed and multi values.','Desc 2','Desc 3']
        expect( filled_resource.borrower_uri ).to    eq ['http://example.org/b_sim','http://example.org/b_sim3']
        expect( filled_resource.clip_number ).to     eq [3,4,5,6]
        expect( filled_resource.answer_count ).to    eq [12345678901234567893,32345678901234567893]
        expect( filled_resource.price ).to           eq [123.43,323.43]
        expect( filled_resource.max_price ).to       eq [12345678901234567.83,32345678901234567.83]
        expect( filled_resource.modified_time ).to   eq ['1995-12-31T23:59:53Z','2015-12-31T23:59:53Z']
        expect( filled_resource.is_proprietary ).to  eq [false,true]
        # expect( filled_resource.latitude       =
        expect( filled_resource.bookEdition ).to     eq ['Ed. 3','Ed. 3a']
      end
    end
  end
end
