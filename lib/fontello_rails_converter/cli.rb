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
      puts "---- open ----"
      if config_file_exists?
        @fontello_api.new_session_from_config  unless @options[:open_existing] == true
        Launchy.open @fontello_api.session_url
      end
    end

    def download
      puts "---- download ----"

      if config_file_exists? && @options[:use_config] == true
        puts "Using '#{options[:config_file]}' to create new fontello session"
        @fontello_api.new_session_from_config
      end

      File.open(@options[:zip_file], "w+") do |file|
        file.write @fontello_api.download_zip_body
      end
      puts green "Downloaded '#{@options[:zip_file]}' from fontello (#{@fontello_api.session_url})"
    end

    def convert
      if @options[:no_download] == true
        puts "Use existing '#{@options[:zip_file]}' file due to `--no-download` switch"
      else
        self.download
      end

      puts "---- convert -----"
      prepare_directories

      if zip_file_exists?
        Zip::File.open(@options[:zip_file]) do |zipfile|
          grouped_files = zipfile.group_by{ |file| file.to_s.split("/")[1] }

          copy_and_convert_stylesheets(zipfile, grouped_files['css'])
          copy_font_files(zipfile, grouped_files['font'])
          copy_config_json(zipfile, grouped_files['config.json'].first)
          copy_and_convert_icon_guide(zipfile, grouped_files['demo.html'].first)
        end
      end
    end

    private

      def prepare_directories
        FileUtils.mkdir_p @options[:font_dir]
        FileUtils.mkdir_p @options[:stylesheet_dir]
        FileUtils.mkdir_p @options[:asset_dir]
        FileUtils.mkdir_p @options[:icon_guide_dir]
      end

      def convert_main_stylesheet(content)
        # asset URLs
        content.gsub! /\.\.\/font\//, ""
        content.gsub!(/url\(([^\(]+)\)/) { |m| "font-url(#{$1})" }

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

      def copy_font_files(zipfile, files)
        puts "font files:"
        files.select{ |file| file.to_s.end_with?(".eot", ".woff", ".ttf", ".svg") }.each do |file|
          filename = file.to_s.split("/").last

          target_file = File.join @options[:font_dir], filename
          zipfile.extract(file, target_file) { true }
          puts green("Copied #{target_file}")
        end
      end

      def copy_config_json(zipfile, config_file)
        puts "config.json:"
        target_file = File.join @options[:font_dir], config_file.to_s.split("/").last
        zipfile.extract(config_file, target_file) { true }
        puts green("Copied #{target_file}")
      end

      def copy_and_convert_stylesheets(zipfile, files)
        puts "stylesheets:"
        files.select{ |file| file.to_s.end_with?('.css') }.each do |file|
          filename = file.to_s.split("/").last

          # extract stylesheet to target location
          target_file = File.join @options[:stylesheet_dir], filename.gsub('.css', @options[:stylesheet_extension])
          zipfile.extract(file, target_file) { true }
          puts green("Copied #{target_file}")

          if !filename.end_with? "animation.css", "-ie7.css", "-codes.css", "-ie7-codes.css", "-embedded.css"
            converted_css = convert_main_stylesheet File.read(target_file).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
            File.open(target_file, 'w') { |f| f.write(converted_css) }
            puts green("Converted #{target_file} for Sass & asset pipeline")
          end
        end
      end

      def copy_and_convert_icon_guide(zipfile, demo_file)
        puts "icon guide (demo.html):"

        target_file = File.join @options[:icon_guide_dir], "fontello-demo.html"
        zipfile.extract(demo_file, target_file) { true }
        puts green("Copied #{target_file}")

        converted_html = File.read(target_file).gsub! /css\//, "/assets/"
        File.open(target_file, 'w') { |f| f.write(converted_html) }
        puts green("Converted demo.html for asset pipeline")
      end

      def config_file_exists?
        if File.exist?(@options[:config_file])
          true
        else
          puts red("missing config file: #{@options[:config_file]}")
          puts red("follow these instructions: https://github.com/railslove/fontello_rails_converter#initial-usage")
          puts red("to setup your project")
          false
        end
      end

      def zip_file_exists?
        if File.exist?(@options[:zip_file])
          true
        else
          puts red("missing zip file: #{@options[:zip_file]}")
          false
        end
      end

  end
end
