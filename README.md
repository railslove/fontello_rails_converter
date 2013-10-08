## fontello_rails_converter

Rake task to be run on .zip file downloaded from fontello.com.  It will copy all the assets to the appropiate places in your Rails app and convert them where necessary.

***STATUS***:  We are in the process (in the `master` branch) of changing this gem to a little CLI utility that should not require rake tasks anymore and should be independent of Rails.


## Usage

1. Add the gem to your Gemfile `gem 'fontello_rails_converter'` and run `bundle install`

1. Download `.zip` file from [http://fontello.com](http://fontello.com) and copy it to your app directory, e.g. into `myapp/tmp/`

1. Run the rake task `rake import_fontello["tmp/fontello-b9661c9f.zip"]`

It will copy all the assets from the fontello .zip file into the appropiate places in your app's `vendor/assets/` directory.

To use them in your app you will need to `@import` the main stylesheet `vendor/assets/stylesheets/fontname.css.scss` in your `application.css.sass` using `@import 'fontname'`.  For special cases you might also want `@import` some of the other stylesheets (`fontname-ie7-codes.css.scss`, `fontname-embedded.css.scss`, `animation.css.scss`, `fontname-ie7.css.scss`, `fontname-codes.css.scss`).

In order for the fonts in `vendor/assets/fonts/` to be served up through the Rails asset pipeline, you will need tell it about font directories, by adding this to your `application.rb`:

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

You can check if the icon font is working correctly by visiting [http://localhost:3000/demo.html](http://localhost:3000/demo.html).

## Updating your font

When you want to add new icons to your fontello font, just grab the `config.json` from `vendor/assets/fonts/` upload it to fontello, select new icons, download the .zip file and start at step 1.

## TODO

Fontello recently added an API ([https://github.com/fontello/fontello#developers-api](https://github.com/fontello/fontello#developers-api)), which would save us all the .zip file downloading hassle.







[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/railslove/fontello_rails_converter/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

