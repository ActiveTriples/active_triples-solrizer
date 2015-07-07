require 'spec_helper'
require 'support/dummy_resource.rb'

describe ActiveTriples::Solrizer::SolrService do

  describe "#generate_solr_document" do
    include_context "shared dummy resource class"

    context "when small number of properties" do
      it "should produce solr doc with all indexed properties" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_short_all_values).generate_solr_document ).to eq expected_solr_doc_short_all_values
      end

      it "should produce solr doc with only properties with values indexed" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_short_partial_values).generate_solr_document ).to eq expected_solr_doc_short_partial_values
      end
    end

    context "when all properties indexed" do
      it "should produce solr doc with all indexed properties" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_indexed).generate_solr_document ).to eq expected_solr_doc_indexed
      end
    end

    context "when all properties stored" do
      it "should produce solr doc with all stored properties" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_stored).generate_solr_document ).to eq expected_solr_doc_stored
      end
    end

    context "when all properties stored and indexed" do
      it "should produce solr doc with all stored indexed properties" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_stored_indexed).generate_solr_document ).to eq expected_solr_doc_stored_indexed
      end
    end

    context "when all properties indexed and multi-valued" do
      it "should produce solr doc with all indexed properties" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_indexed_multi).generate_solr_document ).to eq expected_solr_doc_indexed_multi
      end
    end

    context "when all properties stored and multi-valued" do
      it "should produce solr doc with all stored properties" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_stored_multi).generate_solr_document ).to eq expected_solr_doc_stored_multi
      end
    end

    context "when all properties stored and indexed and multi-valued" do
      it "should produce solr doc with all stored indexed properties" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_stored_indexed_multi).generate_solr_document ).to eq expected_solr_doc_stored_indexed_multi
      end
    end

    context "when all properties indexed and range" do
      it "should produce solr doc with all indexed properties optimized for range" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_indexed_range).generate_solr_document ).to eq expected_solr_doc_indexed_range
      end
    end

    context "when all properties indexed and sortable" do
      it "should produce solr doc with all indexed properties set up for sorting" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_indexed_sort).generate_solr_document ).to eq expected_solr_doc_indexed_sort
      end
    end

    context "when all properties indexed and vectored" do
      it "should produce solr doc with all indexed properties and text fields vectored" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_indexed_vector).generate_solr_document ).to eq expected_solr_doc_indexed_vector
      end
    end

    context "when all properties indexed and guessing the type" do
      it "should produce solr doc with all indexed properties with appropriate types" do
        expect( ActiveTriples::Solrizer::IndexingService.new(dr_indexed_guess).generate_solr_document ).to eq expected_solr_doc_indexed_guess
      end
    end
  end
end
