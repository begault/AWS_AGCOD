# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_agcod/version'

Gem::Specification.new do |spec|
  spec.name          = "aws_agcod"
  spec.version       = AwsAgcod::VERSION
  spec.authors       = ["Agathe Begault"]
  spec.email         = ["agathe@ifeelgoods.com"]
  spec.summary       = "A ruby gem for AWS AGCOD API endpoints"
  spec.description   = 'Amazon Gift Codes On Demand (AGCOD) is a set of systems provided by Amazon and designed to allow partners and third party developers
to create and distribute Amazon gift codes in real-time, on demand.'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_runtime_dependency 'aws4'
  spec.add_runtime_dependency 'httpclient'
end
