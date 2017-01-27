module FontelloRailsConverter
  class Railtie < Rails::Railtie

    initializer "fontello_rails_converter.setup" do |app|
      if app.config.respond_to? (:assets)
        app.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
        app.config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf)$/
      end
    end

  end
end
