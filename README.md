# ActiveTriples::Solrizer

[![Build Status](https://travis-ci.org/ActiveTriples/active_triples-solrizer.png?branch=master)](https://travis-ci.org/ActiveTriples/active_triples-solrizer)
[![Coverage Status](https://coveralls.io/repos/ActiveTriples/active_triples-solrizer/badge.png?branch=master)](https://coveralls.io/r/ActiveTriples/active_triples-solrizer?branch=master)
[![Gem Version](https://badge.fury.io/rb/active_triples-solrizer.svg)](http://badge.fury.io/rb/active_triples-solrizer)

Provides a default solr implementation under the [ActiveTriples](https://github.com/ActiveTriples/ActiveTriples) framework.


## Installation

Add this line to your application's Gemfile:

    gem 'active_triples-solrizer'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_triples-solrizer


## Usage

Property definitions for ActiveTriples resources can be extended by adding a block to define indexing data type and modifiers (see table of supported values below).

```
property :title, :predicate => RDF::SCHEMA.title   do |index|
  index.data_type = :text         # specify the data type of the field in solr.  See (https://github.com/elrayle/active_triples-solrizer/blob/master/solr/schema.xml)[solr/schema.xml] for field type definitions.
  index.as :indexed, :sortable    # specify modifiers for the solr field       
end
```

| data_type   | Notes |
| ----------- | ----- |
| :text       | tokenized text |
| :text_en    | tokenized English text |
| :string     | non-tokenized string |
| :integer    | |
| :long       | |
| :double     | |
| :float      | |
| :boolean    | |
| :date       | format for this date field is of the form 1995-12-31T23:59:59Z; Optional fractional seconds are allowed: 1995-12-31T23:59:59.999Z |
| :coordinate | TBA - used to index the lat and long components for the "location" |
| :location   | TBA - latitude/longitude|
| :guess      | allow guessing of the type based on the type of the property value; NOTE: only checks the type of the first value when multiple values |


| index.as modifiers | works with types | Notes |
| ------------------ | ---------------- | ----- |
| :indexed     | all types except :coordinate           | searchable, but not returned in solr doc unless also has :stored modifier |
| :stored      | all types except :coordinate           | returned in solr doc, but not searchable unless also has :indexed modifier |
| :multiValued | all types except :boolean, :coordinate | NOTE: if not specified and multiple values exist, only the first value is included in the solr doc |
| :sortable    | all types except :boolean, :coordinate, :location | numbers are stored as trie version of numeric type; :string, :text, :text_XX have an extra alphaSort field |
| :range       | all numeric types including :integer, :long, :float, :double, :date | optimize for range queries |
| :vectored    | valid for :text, :text_XX only         |  |

NOTE: Modifiers placed on types that do not support the modifier are ignored.


## Examples

Common prep code for all examples:
```ruby
require 'active_triples'
require 'active_triples/solrizer'

# create an in-memory repository for ad-hoc testing
ActiveTriples::Repositories.add_repository :default, RDF::Repository.new

# configure the solr url
ActiveTriples::Solrizer.configure do |config|
  config.solr_uri = "http://localhost:8983/solr/#/~cores/active_triples"
end

# create a DummyResource for ad-hoc testing
class DummyResource < ActiveTriples::Resource
  configure :type => RDF::URI('http://example.org/SomeClass')
  property :title,            :predicate => RDF::SCHEMA.title       do |index|
    index.data_type = :text
    index.as :indexed, :sortable
  end
  property :description_si,   :predicate => RDF::SCHEMA.description do |index|
    index.data_type = :text
    index.as :stored, :indexed
  end
  property :borrower_uri_i,   :predicate => RDF::SCHEMA.borrower    do |index|
    index.data_type = :string
    index.as :indexed
  end
  property :clip_number_simr, :predicate => RDF::SCHEMA.clipNumber  do |index|
    index.data_type = :integer
    index.as :stored, :indexed, :multiValued, :range
  end
  property :price_s,          :predicate => RDF::SCHEMA.price       do |index|
    index.data_type = :float
    index.as :stored
  end
  property :bookEdition,      :predicate => RDF::SCHEMA.bookEdition # non-indexed property
end


# initialize solr service with defaults
ActiveTriples::Solrizer::SolrService.register
```

### Example: Indexing Service to create solr document

```ruby
# create a new resource
dr = DummyResource.new('http://www.example.org/dr')
dr.title                = 'Test Title'
dr.description_si       = 'Test text description stored and indexed.'
dr.borrower_uri_i       = 'http://example.org/i/b2'
dr.clip_number_simr     = [7,8,9,10]
dr.price_s              = 789.01
dr.bookEdition          = 'Ed. 2'
dr

# get solr doc
doc = ActiveTriples::Solrizer::IndexingService.new(dr).generate_solr_document
# =>  {
#         :id=>"http://www.example.org/dr",
#         :at_model_ssi=>"DummyResource",
#         :object_profile_ss=>expected_object_profile_short_all_values,
#         :title_ti=>"Test Title",
#         :title_ssort=>"Test Title",
#         :description_si_tsi=>"Test text description stored and indexed.",
#         :borrower_uri_i_si=>"http://example.org/i/b2",
#         :clip_number_simr_itsim=>[7,8,9,10],
#         :price_s_fs=>789.01
#     }


# persist doc to solr
ActiveTriples::Solrizer::SolrService.add(doc)
ActiveTriples::Solrizer::SolrService.commit
```

### Example: Profile Indexing Service to serialize/deserialize resource

```ruby
# create a new resource with all properties having values
dr1 = DummyResource.new('http://www.example.org/dr1')
dr1.title                = 'Test Title'
dr1.description_si       = 'Test text description stored and indexed.'
dr1.borrower_uri_i       = 'http://example.org/i/b2'
dr1.clip_number_simr     = [7,8,9,10]
dr1.price_s              = 789.01
dr1.bookEdition          = 'Ed. 2'
dr1

# serialize resource into object profile
object_profile1 = ActiveTriples::Solrizer::ProfileIndexingService.new(dr1).export
# =>    '{"id":"http://www.example.org/dr1",'\
#        '"title":["Test Title"],'\
#        '"description_si":["Test text description stored and indexed."],'\
#        '"borrower_uri_i":["http://example.org/i/b2"],'\
#        '"clip_number_simr":[7,8,9,10],'\
#        '"price_s":[789.01],'\
#        '"bookEdition":["Ed. 2"]}'

# deserialize resource from object profile
dr1_filled = ActiveTriples::Solrizer::ProfileIndexingService.new().import( object_profile1, DummyResource )
dr1_filled.attributes
# => {"id"=>"http://www.example.org/dr2",
#     "title"=>["Test Title"],
#     "description_si"=>["Test text description stored and indexed."],
#     "borrower_uri_i"=>["http://example.org/i/b2"],
#     "clip_number_simr"=>[7, 8, 9, 10],
#     "borrower_uri_i"=>[],
#     "clip_number_simr"=>[],
#     "price_s"=>[789.01],
#     "bookEdition"=>["Ed. 2"]}

# create a new resource with some properties with unset values
dr2 = DummyResource.new('http://www.example.org/dr2')
dr2.title                = 'Test Title'
dr2.description_si       = 'Test text description stored and indexed.'
dr2.price_s              = 789.01
dr2.bookEdition          = 'Ed. 2'
dr2

# serialize resource into object profile
object_profile2 = ActiveTriples::Solrizer::ProfileIndexingService.new(dr2).export
# =>    '{"id":"http://www.example.org/dr1",'\
#        '"title":["Test Title"],'\
#        '"description_si":["Test text description stored and indexed."],'\
#        '"borrower_uri_i":[],'\
#        '"clip_number_simr":[],'\
#        '"price_s":[789.01],'\
#        '"bookEdition":["Ed. 2"]}'

# deserialize resource from object profile
dr2_filled = ActiveTriples::Solrizer::ProfileIndexingService.new().import( object_profile2, DummyResource )
dr2_filled.attributes
# => {"id"=>"http://www.example.org/dr2",
#     "title"=>["Test Title"],
#     "description_si"=>["Test text description stored and indexed."],
#     "borrower_uri_i"=>[],
#     "clip_number_simr"=>[],
#     "price_s"=>[789.01],
#     "bookEdition"=>["Ed. 2"]}
```


### Example: Properties Indexing Service to generate solr fields based on property definitions

```ruby
# NOTE re-use dr1 and dr2 from object profile examples

# generate property fields
property_fields1 = ActiveTriples::Solrizer::PropertiesIndexingService.new(dr1).export
# => {
#        :title_ti=>"Test Title",
#        :title_ssort=>"Test Title",
#        :description_si_tsi=>"Test text description stored and indexed.",
#        :borrower_uri_i_si=>"http://example.org/i/b2",
#        :clip_number_simr_itsim=>[7,8,9,10],
#        :price_s_fs=>789.01
#    }

# generate property fields
property_fields2 = ActiveTriples::Solrizer::PropertiesIndexingService.new(dr2).export
# => {
#        :title_ti=>"Test Title",
#        :title_ssort=>"Test Title",
#        :description_si_tsi=>"Test text description stored and indexed.",
#        :price_s_fs=>789.01
#    }
```

## Development Notes:

* I would like to see this expand to support specification of facets.
* The location and coordinate field types have not been tested and do not have examples.
* Some of the code in solr_service.rb is untested.  It was copied from ActiveFedora as is.  Mentions in the code to querying have not been tested.  Query code was not copied at the time this document was written.


## Contributing

Please observe the following guidelines:

 - Do your work in a feature branch based on ```master``` and rebase before submitting a pull request.
 - Write tests for your contributions.
 - Document every method you add using YARD annotations. (_Note: Annotations are sparse in the existing codebase, help us fix that!_)
 - Organize your commits into logical units.
 - Don't leave trailing whitespace (i.e. run ```git diff --check``` before committing).
 - Use [well formed](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) commit messages.

