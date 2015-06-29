# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_triples/solrizer/version"

Gem::Specification.new do |s|
  s.name        = "active_triples-solrizer"
  s.version     = ActiveTriples::Solrizer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["E. Lynette Rayle"]
  s.homepage    = 'https://github.com/ActiveTriples/active_triples-solrizer'
  s.email       = 'elr37@cornell.edu'
  s.summary     = %q{Provide default solrizer implementation for ActiveTriples.}
  s.description = %q{active_triples-solrizer provides a default solr indexing implementation for ActiveTriples.}
  s.license     = "APACHE2"
  s.required_ruby_version     = '>= 2.0.0'

  s.add_dependency 'rsolr', "~> 1.0.10"
  s.add_dependency('active-triples', '~> 0.7')
  s.add_dependency('activesupport', '>= 3.0.0')
  s.add_dependency('solrizer')
  s.add_dependency('json', '>= 1.8')

  s.add_development_dependency('pry')
  s.add_development_dependency('pry-byebug')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_development_dependency('coveralls')
  s.add_development_dependency('guard-rspec')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")

  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
end
