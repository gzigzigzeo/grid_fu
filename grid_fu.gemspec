# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grid_fu/version'

Gem::Specification.new do |gem|
  gem.name          = "grid_fu"
  gem.version       = GridFu::VERSION
  gem.authors       = ["Victor Sokolov"]
  gem.email         = ["gzigzigzeo@gmail.com"]
  gem.description   = %q{HTML table generator}
  gem.summary       = %q{HTML table generator}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'active_support', '~> 3'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec-html-matchers'
end
