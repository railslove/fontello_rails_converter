# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fontello_rails_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "fontello_rails_converter"
  spec.version       = FontelloRailsConverter::VERSION
  spec.authors       = ["Jakob Hilden"]
  spec.email         = ["jakobhilden@gmail.com"]
  spec.description   = %q{Gem for opening up your current fontello font in the browser from the command line and copying & converting the files for your Rails app (inclusively Sass enhancements).}
  spec.summary       = %q{CLI gem for comfortably working with custom icon fonts from fontello.com in your Rails apps}
  spec.homepage      = "https://github.com/railslove/fontello_rails_converter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency "rubyzip", "~> 1.0"
  spec.add_runtime_dependency "launchy"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "activesupport"
end
