# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fontello_rails_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "fontello_rails_converter"
  spec.version       = FontelloRailsConverter::VERSION
  spec.authors       = ["Jakob Hilden"]
  spec.email         = ["jakobhilden@gmail.com"]
  spec.description   = %q{Rake task to be run on .zip file downloaded from fontello.com.  It will copy all the assets to the appropiate places in your Rails app and convert them where necessary.}
  spec.summary       = %q{Convert/import icon font .zip files downloaded from fontello.com into your Rails app}
  spec.homepage      = "https://github.com/railslove/fontello_rails_converter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", ">= 3.1"
  spec.add_runtime_dependency "rubyzip", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
