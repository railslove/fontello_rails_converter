# Changelog

### master (unreleased)

* allow setting global options using a .yml file (e.g. /rails_root/config/fontello_rails_converter.yml)
* allow configuration of the stylesheet extension for the SCSS files (`.css.scss` or `.scss`)

### 0.2.0

* removed deprecated rake task
* updated railtie integration, so that rails will find and precompile the asset in `vendor/assets/fonts`

### 0.1.1

* only an update to the gemspec description

### 0.1.0

* convert the gem to a CLI tool with `open` and `convert` commands
* deprecated rake task
* make use of the fontello API

### 0.0.2

* updated rubyzip dependency

### 0.0.1

* initial release
