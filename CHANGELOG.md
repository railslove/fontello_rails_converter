# 0.4.1

* [bugfix] for case where font name in `config.json` is empty #30

# 0.4.0

* added new `copy` command for cases where you don't want to convert assets
* gem now depends on Ruby 2.x

# 0.3.3

* [improvement] changed default stylesheet file extension from `.css.scss` to `.scss` because of recent change in `sass-rails` (see #26)
* [bugfix] fixed stylesheet extension option parsing #25

# 0.3.2

* [bugfix] the `config.json` wasn't being copied anymore

# 0.3.1

* allow configuration (and automatic creation) of icon guide directory (/rails_root/public/fontello-demo.html), fixes #19
* more verbose/helpful CLI output
* add `-v`/`--version` switch to CLI for printing out the current version

# 0.3.0

* allow setting global options using a .yml file (e.g. /rails_root/config/fontello_rails_converter.yml)
* allow configuration of the stylesheet extension for the SCSS files (`.css.scss` or `.scss`)
* fail gracefully when there is no config file yet (90ec5942383cc5558a097aa78c4adcc809ab6a0e)
* fixes for 2 encoding issues #11 and #12 by @hqm42

# 0.2.0

* removed deprecated rake task
* updated railtie integration, so that rails will find and precompile the asset in `vendor/assets/fonts`

# 0.1.1

* only an update to the gemspec description

# 0.1.0

* convert the gem to a CLI tool with `open` and `convert` commands
* deprecated rake task
* make use of the fontello API

# 0.0.2

* updated rubyzip dependency

# 0.0.1

* initial release
