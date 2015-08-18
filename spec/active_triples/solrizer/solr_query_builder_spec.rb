require 'spec_helper'

describe ActiveTriples::Solrizer::SolrQueryBuilder do
  describe "raw_query" do
    it "should generate a raw query clause" do
      expect(ActiveTriples::Solrizer::SolrQueryBuilder.raw_query('id', "my:_ID1_")).to eq '_query_:"{!raw f=id}my:_ID1_"'
    end
  end

  describe '#construct_query_for_ids' do
    it "should generate a useable solr query from an array of Fedora ids" do
      expect(ActiveTriples::Solrizer::SolrQueryBuilder.construct_query_for_ids(["my:_ID1_", "my:_ID2_", "my:_ID3_"])).to eq '_query_:"{!raw f=id}my:_ID1_" OR _query_:"{!raw f=id}my:_ID2_" OR _query_:"{!raw f=id}my:_ID3_"'

    end
    it "should return a valid solr query even if given an empty array as input" do
      expect(ActiveTriples::Solrizer::SolrQueryBuilder.construct_query_for_ids([""])).to eq "id:NEVER_USE_THIS_ID"
    end
  end

end

