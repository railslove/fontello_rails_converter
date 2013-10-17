## fontello_rails_converter

CLI gem for comfortably working with icon fonts (open, download, convert) from [http://fontello.com](http://fontello.com) for usage in Rails apps.

Included features:

* **Open** up the current fontello font in the browser
* **Download** font zip file from fontello
* **Copy & convert** files from the zip into rails app (inclusively Sass enhancements)


## Initial usage

#### Rails app setup

1. Add the gem to your Gemfile `gem 'fontello_rails_converter'` and run `bundle install`

1. In order for the fonts in `vendor/assets/fonts/` to be served up through the Rails asset pipeline, you will need tell it about your vendor fonts directory, using this:

```ruby
# config/application.rb
config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
```

#### Get your icon font

1. Download your initial `.zip` file from [http://fontello.com](http://fontello.com) and save it to `myapp/tmp/fontello.zip`

1. Run `fontello convert` inside your app's root directory

It will copy all the assets from the `fontello.zip` file into the appropiate places in your app's `vendor/assets/` directory.

#### Use the font in your app

To use your font in your app you will need to `@import` the main stylesheet `vendor/assets/stylesheets/fontname.css.scss` in your `application.css.sass` using `@import 'fontname'`.

You can check if the icon font is working correctly by visiting [http://localhost:3000/fontello-demo.html](http://localhost:3000/fontello-demo.html).


## Updating your fontello font

When you want to add new icons to your fontello font you can open it in the browser using `fontello open` and select all the icons you want to add.

Next you can either download the `.zip` file, as described in the initial usage, or you can save the session and copy the fontello session id (from the URL) and download the `.zip` file with `fontello download -id {1234myfontelloid5678}`.

Finally you run `fontello convert` again.

## More help

For more help run `fontello --help`

## Misc

#### Additional fontello stylesheets

Besides the main stylesheet (`fontname.css.scss`) fontello also provides a couple of additional stylesheets that you might want to `@import` in your app for special use cases:  `fontname-ie7-codes.css.scss`, `fontname-embedded.css.scss`, `animation.css.scss`, `fontname-ie7.css.scss`, `fontname-codes.css.scss`


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/railslove/fontello_rails_converter/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

