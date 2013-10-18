require 'fileutils'
require 'launchy'
require 'zip'

module FontelloRailsConverter
  class Cli
    include ColorizedOutput

    def initialize(options)
      @options = options
      @fontello_api = FontelloApi.new @options
    end

    def open
      @fontello_api.new_session_from_config  unless @options[:open_existing] == true
      Launchy.open @fontello_api.session_url
    end

    def download
      @fontello_api.new_session_from_config  if @options[:use_config] == true
      File.open(@options[:zip_file], "w+") do |file|
        file.write @fontello_api.download_zip_body
      end
    end

    def convert
      self.download  unless @options[:no_download] == true || !config_file_exists?
      self.prepare_directories

      Zip::File.open(@options[:zip_file]) do |zipfile|
        zipfile.each do |file|
          filename = file.to_s.split("/").last

          # stylesheets
          if filename.end_with? '.css'
            # extract stylesheet to target location
            target_file = File.join @options[:stylesheet_dir], "#{filename}.scss"
            zipfile.extract(file, target_file) { true }
            puts green("copied #{target_file}")

            if !filename.end_with? "animation.css", "-ie7.css", "-codes.css", "-ie7-codes.css", "-embedded.css"
              converted_css = self.convert_main_stylesheet File.read(target_file)
              File.open(target_file, 'w') { |f| f.write(converted_css) }
              puts green("converted #{target_file} for Sass & asset pipeline")
            end

          # font files
          elsif filename.end_with? ".eot", ".woff", ".ttf", ".svg", "config.json"
            target_file = File.join @options[:font_dir], filename
            zipfile.extract(file, target_file) { true }
            puts green("copied #{target_file}")

          # demo.html
          elsif filename == 'demo.html'
            target_file = File.join @options[:rails_root_dir], "public", "fontello-demo.html"
            zipfile.extract(file, target_file) { true }
            puts green("copied #{target_file}")

            converted_html = convert_demo_html File.read(target_file)
            File.open(target_file, 'w') { |f| f.write(converted_html) }
            puts green("converted #{filename}'s HTML for asset pipeline")
          end

        end
      end
    end

    def prepare_directories
      FileUtils.mkdir_p @options[:font_dir]
      FileUtils.mkdir_p @options[:stylesheet_dir]
      FileUtils.mkdir_p @options[:asset_dir]
    end

    def convert_main_stylesheet(content)
      # asset URLs
      content.gsub! /\.\.\/font\//, ""
      content.gsub!(/url\(([^\(]+)\)/) { |m| "url(font-path(#{$1}))" }

      # turn icon base class into placeholder selector
      content.gsub! /\[class\^="icon-[^\{]+{/m, "%icon-base {"

      # get icons
      icons = content.scan(/\.(icon-\S+):before/).map(&:first)

      # convert icon classes to placeholder selectors
      content.gsub!(/^\.(icon-\S+:before) { (.+)$/) { |m| "%#{$1} { @extend %icon-base; #{$2}" }

      # recreate icon classes using the mixins
      if icons.any?
        content += "\n\n"
        icons.each do |icon|
          content += ".#{icon} { @extend %#{icon}; }\n"
        end
      end

      return content
    end

    private

      def config_file_exists?
        @options[:config_file] && File.exist?(@options[:config_file])
      end

      def convert_demo_html(content)
        content.gsub! /css\//, "/assets/"
      end

  end
end
