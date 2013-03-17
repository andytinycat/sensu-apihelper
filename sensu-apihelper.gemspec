# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sensu-apihelper/version'

Gem::Specification.new do |gem|
  gem.name          = "sensu-apihelper"
  gem.version       = Sensu::Apihelper::VERSION
  gem.authors       = ["Andy Sykes"]
  gem.email         = ["github@tinycat.co.uk"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'rest-client'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
end
