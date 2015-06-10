# ActiveTriples::Solrizer



UNDER CONSTRUCTION - Needs total overhaul!!!



[![Build Status](https://travis-ci.org/ActiveTriples/active_triples-solrizer.png?branch=master)](https://travis-ci.org/ActiveTriples/active_triples-solrizer)
[![Coverage Status](https://coveralls.io/repos/ActiveTriples/active_triples-solrizer/badge.png?branch=master)](https://coveralls.io/r/ActiveTriples/active_triples-solrizer?branch=master)
[![Gem Version](https://badge.fury.io/rb/active_triples-solrizer.svg)](http://badge.fury.io/rb/active_triples-solrizer)

Provides a default solr implementation under the [ActiveTriples](https://github.com/ActiveTriples/ActiveTriples) 
framework.


## Installation

Add this line to your application's Gemfile:

    gem 'active_triples-solrizer'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_triples-solrizer


## Usage

**Utilities**

* Solrizer


### Solrizer

Common prep code for all examples:
```ruby
require 'active_triples'
require 'active_triples/solrizer'

# create an in-memory repository for ad-hoc testing
ActiveTriples::Repositories.add_repository :default, RDF::Repository.new

# create a DummyResource for ad-hoc testing
class DummyResource < ActiveTriples::Resource
  configure :base_uri => "http://example.org",
            :type => RDF::URI("http://example.org/SomeClass"),
            :repository => :default

  property :title, :predicate => RDF::DC.title  # :type => XSD.string
end

# initialize solr service with defaults
ss = ActiveTriples::Solrizer::SolrService.new
```

#### Example:
```ruby
# create a new resource and get solr doc
dr = DummyResource.new( 'dr1' )
is = ActiveTriples::Solrizer::IndexingService.new(ca)
doc = is.generate_solr_document

# persist doc to solr
ss.add(doc)
ss.commit
```



## Contributing

Please observe the following guidelines:

 - Do your work in a feature branch based on ```master``` and rebase before submitting a pull request.
 - Write tests for your contributions.
 - Document every method you add using YARD annotations. (_Note: Annotations are sparse in the existing codebase, help us fix that!_)
 - Organize your commits into logical units.
 - Don't leave trailing whitespace (i.e. run ```git diff --check``` before committing).
 - Use [well formed](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) commit messages.

