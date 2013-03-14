## fontello-rails-converter

A Ruby script to convert icon font assets coming from http://fontello.com for the Rails asset pipeline.

## Usage

1. Download `.zip` file from [http://fontello.com](http://fontello.com) and extract it

1. Copy the `fontello_scss_converter.rb` into the extract directory

1. Run `ruby fontello_scss_converter.rb`

1. Copy the font files from the `/font` directory into `yourrailsapp/vendor/assets/fonts/`

1. Copy the `.scss` files from the `/css` directory into `yourrailsapp/vendor/assets/stylesheets/`

1. It's also recommended to keep the `config.json` file from Fontello in your repository for future icon set downloads.  I like to put it into `yourrailsapp/vendor/assets/fonts/`

Now you simply need to `@import` the appropiate stylesheet in your application and you are good to go.  Usually only doing `@import <your_font_name>` should be enough.

You can copy the `demo.html` to `yourrailsapp/public/styleguide/icon_demo.html` for icon reference inside the app.


