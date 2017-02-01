## fontello_rails_converter

[![Build Status](https://travis-ci.org/railslove/fontello_rails_converter.png?branch=master)](https://travis-ci.org/railslove/fontello_rails_converter)

CLI gem for comfortably working with icon fonts from [http://fontello.com](http://fontello.com) for usage in Rails apps.

Main features:

* **Open** up your current fontello font in the browser from the command line
* **Copy & convert** files from the zip into rails app (inclusively [Sass enhancements](#sass-enhacements))


## Initial usage

#### Rails app setup

Add the gem to your Gemfile `gem 'fontello_rails_converter'` and run `bundle install`

Read the [note](https://github.com/railslove/fontello_rails_converter#gemfile-environment) below to decide whether to put the gem into the `production` or `development` group in your Gemfile.

#### Get your icon font

1. Download your initial `.zip` file from [http://fontello.com](http://fontello.com) and save it to `myapp/tmp/fontello.zip`

1. Run `bundle exec fontello convert --no-download` inside your app's root directory

It will copy all the assets from the `fontello.zip` file into the appropiate places in your app's `vendor/assets/` directory.

#### Use the font in your app

To use your font in your app you will need to `@import` the main stylesheet `vendor/assets/stylesheets/fontname.css.scss` in your `application.css.sass` using `@import 'fontname'`.

You can check if the icon font is working correctly by visiting [http://localhost:3000/fontello-demo.html](http://localhost:3000/fontello-demo.html).


## Updating your existing fontello font

When you want to add new icons to your existing fontello font you can open it in the browser by using `fontello open` and select all the additional icons you want to add.

Next you click the 'Save session' button on the fontello website. After that you can download, copy and convert the changed font by running `bundle exec fontello convert` (it has persisted the session id in `tmp/fontello_session_id` and will used that to pull down your changed font).

Alternatively, you can download & save the `.zip` file just like in the initial setp and run `bundle exec fontello convert --no-download` to use the manually downloaded file instead of pulling it down from fontello.

## Options

* `--webpack` [command: `convert`]: generate the stylesheets for use with webpack, prefixing the font file names with the tilde (~). Es: `src: url('~fontello.eot?99999999');`. See [Webpack](#webpack).

## More help

For more help run `fontello --help`

## Sass enhacements

The conversion process will do a couple of things to make working with the main fontello stylesheet easier in Rails/Sass:

* It will convert font paths to use `font-url` (unless you use the `--webpack` option)
* It will create [Sass placeholder selectors](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#placeholder_selectors_) (e.g. `%icon-foo` for all the icons) so you have the choice to use the CSS classes in your markup or to `@extend` the placeholders in your Sass code

## Webpack

You can convert the fontello stylesheets for use with Webpack instead of Sprockets.

If you have not alreday done it, you must

* add the vendor paths to the resolve roots of Webpack

```javascript
[...]
const path = require("path")
const railsRoot = path.join(__dirname, ".")
[...]
module.exports = {
  [...]
  resolve: {
    root: [
      [...]
      path.join(railsRoot, './vendor/assets/javascripts'),
      path.join(railsRoot, './vendor/assets/stylesheets'),
      path.join(railsRoot, './vendor/assets/fonts'),
    ],
},

```

* add optional parameters to the `test` key for the loader of the fonts files

```javascript
test: /\.(png|woff|woff2|eot|ttf|svg)(\?[a-z0-9=.]+)?$/,
```

## Misc

#### Additional fontello stylesheets

Besides the main stylesheet (`fontname.css.scss`) fontello also provides a couple of additional stylesheets that you might want to `@import` in your app for special use cases:  `fontname-ie7-codes.css.scss`, `fontname-embedded.css.scss`, `animation.css.scss`, `fontname-ie7.css.scss`, `fontname-codes.css.scss`

#### Gemfile environment

If you don't want to load this gem in your app's production environment to save a tiny bit of memory, you can also just add it to the `:development` group in your Gemfile.  The only thing you might need to change is to tell rails to add `vendor/assets/fonts` to the precompile load paths see: https://github.com/railslove/fontello_rails_converter/blob/master/lib/fontello_rails_converter/railtie.rb

#### Configuration file

By default the gem will look in `Rails.root.join("config", "fontello_rails_converter.yml")` for configuration options.  You can use this to set default options for the tool.
