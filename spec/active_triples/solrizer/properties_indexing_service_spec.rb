require 'spec_helper'
require 'support/dummy_resource.rb'

describe ActiveTriples::Solrizer::PropertiesIndexingService do
  include_context "shared dummy resource class"

  describe "#export" do
    context "when small number of properties" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_short_all_values).export ).to eq expected_solr_properties_short_all_values
      end

      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_short_partial_values).export ).to eq expected_solr_properties_short_partial_values
      end
    end

    context "when all properties indexed" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_indexed).export ).to eq expected_solr_properties_indexed
      end
    end

    context "when all properties stored" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_stored).export ).to eq expected_solr_properties_stored
      end
    end

    context "when all properties stored and indexed" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_stored_indexed).export ).to eq expected_solr_properties_stored_indexed
      end
    end

    context "when all properties indexed and multi-valued" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_indexed_multi).export ).to eq expected_solr_properties_indexed_multi
      end
    end

    context "when all properties stored and multi-valued" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_stored_multi).export ).to eq expected_solr_properties_stored_multi
      end
    end

    context "when all properties stored and indexed and multi-valued" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_stored_indexed_multi).export ).to eq expected_solr_properties_stored_indexed_multi
      end
    end

    context "when all properties indexed and range" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_indexed_range).export ).to eq expected_solr_properties_indexed_range
      end
    end

    context "when all properties indexed and sortable" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_indexed_sort).export ).to eq expected_solr_properties_indexed_sort
      end
    end

    context "when all properties indexed and vectored" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_indexed_vector).export ).to eq expected_solr_properties_indexed_vector
      end
    end

    context "when all properties indexed and guessing the type" do
      it "should produce object profile holding serialization of the resource" do
        expect( ActiveTriples::Solrizer::PropertiesIndexingService.new(dr_indexed_guess).export ).to eq expected_solr_properties_indexed_guess
      end
    end
  end
end
