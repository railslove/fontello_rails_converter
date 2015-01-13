## fontello_rails_converter

[![Build Status](https://travis-ci.org/railslove/fontello_rails_converter.png?branch=master)](https://travis-ci.org/railslove/fontello_rails_converter)

CLI gem for comfortably working with icon fonts from [http://fontello.com](http://fontello.com) for usage in Rails apps.

Main features:

* **Open** up your current fontello font in the browser from the command line
* **Copy & convert** files from the zip into rails app (inclusively Sass enhancements)


## Initial usage

#### Rails app setup

Add the gem to your Gemfile `gem 'fontello_rails_converter'` and run `bundle install`

#### Get your icon font

1. Download your initial `.zip` file from [http://fontello.com](http://fontello.com) and save it to `myapp/tmp/fontello.zip`

1. Run `fontello convert --no-download` inside your app's root directory

It will copy all the assets from the `fontello.zip` file into the appropiate places in your app's `vendor/assets/` directory.

#### Use the font in your app

To use your font in your app you will need to `@import` the main stylesheet `vendor/assets/stylesheets/fontname.css.scss` in your `application.css.sass` using `@import 'fontname'`.

You can check if the icon font is working correctly by visiting [http://localhost:3000/fontello-demo.html](http://localhost:3000/fontello-demo.html).


## Updating your existing fontello font

When you want to add new icons to your existing fontello font you can open it in the browser by using `fontello open` and select all the additional icons you want to add.

Next you click the 'Save session' button on the fontello website. After that you can download, copy and convert the changed font by running `fontello convert` (it has persisted the session id in `tmp/fontello_session_id` and will used that to pull down your changed font).

Alternatively, you can download & save the `.zip` file just like in the initial setp and run `fontello convert --no-download` to use the manually downloaded file instead of pulling it down from fontello.

## More help

For more help run `fontello --help`

## Misc

#### Additional fontello stylesheets

Besides the main stylesheet (`fontname.css.scss`) fontello also provides a couple of additional stylesheets that you might want to `@import` in your app for special use cases:  `fontname-ie7-codes.css.scss`, `fontname-embedded.css.scss`, `animation.css.scss`, `fontname-ie7.css.scss`, `fontname-codes.css.scss`

#### Gemfile environment

If you don't want to load this gem in your app's production environment to save a tiny bit of memory, you can also just add it to the `:development` group in your Gemfile.  The only thing you might need to change is to tell rails to add `vendor/assets/fonts` to the precompile load paths see: https://github.com/railslove/fontello_rails_converter/blob/master/lib/fontello_rails_converter/railtie.rb
