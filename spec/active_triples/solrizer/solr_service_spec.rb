require 'spec_helper'

describe ActiveTriples::Solrizer::SolrService do
  before do
    Thread.current[:solr_service]=nil
  end

  after(:all) do
    ActiveTriples::Solrizer::SolrService.register(ActiveTriples::Solrizer.configuration.solr_uri)
  end

  it "should take a n-arg constructor and configure for localhost" do
    expect(RSolr).to receive(:connect).with(:read_timeout => 120, :open_timeout => 120, :url => 'http://localhost:8983/solr/')
    ActiveTriples::Solrizer::SolrService.register
  end
  it "should accept host arg into constructor" do
    expect(RSolr).to receive(:connect).with(:read_timeout => 120, :open_timeout => 120, :url => 'http://fubar')
    ActiveTriples::Solrizer::SolrService.register('http://fubar')
  end
  it "should clobber options" do
    expect(RSolr).to receive(:connect).with(:read_timeout => 120, :open_timeout => 120, :url => 'http://localhost:8983/solr/', :autocommit=>:off, :foo=>:bar)
    ActiveTriples::Solrizer::SolrService.register(nil, {:autocommit=>:off, :foo=>:bar})
  end

  it "should set the threadlocal solr service" do
    expect(RSolr).to receive(:connect).with(:read_timeout => 120, :open_timeout => 120, :url => 'http://localhost:8983/solr/', :autocommit=>:off, :foo=>:bar)
    ss = ActiveTriples::Solrizer::SolrService.register(nil, {:autocommit=>:off, :foo=>:bar})
    expect(Thread.current[:solr_service]).to eq ss
    expect(ActiveTriples::Solrizer::SolrService.instance).to eq ss
  end
  it "should try to initialize if the service not initialized, and fail if it does not succeed" do
    expect(Thread.current[:solr_service]).to be_nil
    expect(ActiveTriples::Solrizer::SolrService).to receive(:register)
    expect(proc{ActiveTriples::Solrizer::SolrService.instance}).to raise_error(ActiveTriples::Solrizer::SolrNotInitialized)
  end

  describe ".query" do
    it "should call solr" do
      mock_conn = double("Connection")
      stub_result = double("Result")
      expect(mock_conn).to receive(:get).with('select', :params=>{:q=>'querytext', :qt=>'standard'}).and_return(stub_result)
      allow(ActiveTriples::Solrizer::SolrService).to receive(:instance).and_return(double("instance", conn: mock_conn))
      expect(ActiveTriples::Solrizer::SolrService.query('querytext', :raw=>true)).to eq stub_result
    end
  end
  describe ".count" do
    it "should return a count of matching records" do
      mock_conn = double("Connection")
      stub_result = {'response' => {'numFound'=>'7'}}
      expect(mock_conn).to receive(:get).with('select', :params=>{:rows=>0, :q=>'querytext', :qt=>'standard'}).and_return(stub_result)
      allow(ActiveTriples::Solrizer::SolrService).to receive(:instance).and_return(double("instance", conn: mock_conn))
      expect(ActiveTriples::Solrizer::SolrService.count('querytext')).to eq 7
    end
    it "should accept query args" do
      mock_conn = double("Connection")
      stub_result = {'response' => {'numFound'=>'7'}}
      expect(mock_conn).to receive(:get).with('select', :params=>{:rows=>0, :q=>'querytext', :qt=>'standard', :fq=>'filter'}).and_return(stub_result)
      allow(ActiveTriples::Solrizer::SolrService).to receive(:instance).and_return(double("instance", conn: mock_conn))
      expect(ActiveTriples::Solrizer::SolrService.count('querytext', :fq=>'filter', :rows=>10)).to eq 7
    end
  end
  describe ".add" do
    it "should call solr" do
      mock_conn = double("Connection")
      doc = {'id' => '1234'}
      expect(mock_conn).to receive(:add).with(doc, {:params=>{}})
      allow(ActiveTriples::Solrizer::SolrService).to receive(:instance).and_return(double("instance", conn: mock_conn))
      ActiveTriples::Solrizer::SolrService.add(doc)
    end
  end
  describe ".commit" do
    it "should call solr" do
      mock_conn = double("Connection")
      doc = {'id' => '1234'}
      expect(mock_conn).to receive(:commit)
      allow(ActiveTriples::Solrizer::SolrService).to receive(:instance).and_return(double("instance", conn: mock_conn))
      ActiveTriples::Solrizer::SolrService.commit()
    end
  end
end

