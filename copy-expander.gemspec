# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'copy-expander/version'

Gem::Specification.new do |spec|
  spec.name          = "copy-expander"
  spec.version       = Dfhmdf::VERSION
  spec.authors       = ["Dave Nicolette"]
  spec.email         = ["davenicolette@gmail.com"]
  spec.summary       = %q{Expands nested COBOL COPY REPLACING statements}
  spec.description   = %q{Expands nested COBOL COPY REPLACING statements}
  spec.homepage      = "http://github.com/neopragma/copy-expander"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop"
end
