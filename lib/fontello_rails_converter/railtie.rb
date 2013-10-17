module FontelloRailsConverter
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), '../tasks/fontello_rails_converter.rake')
    end

    initializer "fontello_rails_converter.setup" do |app|
      app.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    end
  end
end