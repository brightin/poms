# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poms/version'

Gem::Specification.new do |spec|
  spec.name          = 'poms'
  spec.version       = Poms::VERSION
  spec.authors       = ['Tom Kruijsen']
  spec.email         = ['tom@brightin.nl']
  spec.description   = 'Interface to POMS CouchDB API'
  spec.summary       = 'Interface to POMS CouchDB API'
  spec.homepage      = 'https://github.com/brightin/poms'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'addressable'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.20.0'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
