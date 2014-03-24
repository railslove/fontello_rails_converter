# Changelog

### master (unreleased)

* more verbose CLI output
* add `-v`/`--version` switch to CLI for printing out the current version

### 0.3.0

* allow setting global options using a .yml file (e.g. /rails_root/config/fontello_rails_converter.yml)
* allow configuration of the stylesheet extension for the SCSS files (`.css.scss` or `.scss`)
* fail gracefully when there is no config file yet (90ec5942383cc5558a097aa78c4adcc809ab6a0e)
* fixes for 2 encoding issues #11 and #12 by @hqm42

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
