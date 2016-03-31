module FontelloRailsConverter
  class Railtie < Rails::Railtie

    initializer "fontello_rails_converter.setup" do |app|
      app.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
      app.config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf)$/
    end

  end
end
