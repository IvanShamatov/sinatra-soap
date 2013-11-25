# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/soap/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra-soap"
  spec.version       = Sinatra::Soap::VERSION
  spec.authors       = ["Ivan Shamatov"]
  spec.email         = ["status.enable@gmail.com"]
  spec.description   = %q{Handling SOAP requests for sinatra}
  spec.summary       = %q{Handling SOAP requests for sinatra}
  spec.homepage      = "https://github.com/IvanShamatov/sinatra-soap"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "nori", ">= 2.0.0"
end
