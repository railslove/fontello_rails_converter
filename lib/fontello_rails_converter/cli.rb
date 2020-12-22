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

    def copy
      if @options[:no_download] == true
        puts "Use existing '#{@options[:zip_file]}' file due to `--no-download` switch"
      else
        download
      end

      puts "---- copy -----"
      prepare_directories

      if zip_file_exists?
        Zip::File.open(@options[:zip_file]) do |zipfile|
          grouped_files = zipfile.group_by{ |file| file.to_s.split("/")[1] }

          copy_stylesheets(zipfile, grouped_files['css'])
          copy_font_files(zipfile, grouped_files['font'])
          copy_config_json(zipfile, grouped_files['config.json'].first)
          copy_icon_guide(zipfile, grouped_files['demo.html'].first)
        end
      end
    end

    def convert
      copy

      puts "---- convert -----"
      convert_stylesheets(@options[:webpack])
      convert_icon_guide

    end

    private

      def prepare_directories
        FileUtils.mkdir_p @options[:font_dir]
        FileUtils.mkdir_p @options[:stylesheet_dir]
        FileUtils.mkdir_p @options[:asset_dir]
        FileUtils.mkdir_p @options[:icon_guide_dir]
      end

      def convert_stylesheets(webpack)
        ['', '-embedded'].each do |stylesheet_postfix|
          source_file = stylesheet_file(postfix: stylesheet_postfix)
          content = File.read(source_file).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

          content = sass_enhance(content)
          puts "enhancing with Sass placeholder selectors"

          if webpack
            content = convert_for_webpack(content)
            puts "converting for webpack"
          else
            content = convert_for_asset_pipeline(content)
            puts "converting for asset pipeline"
          end

          target_file = stylesheet_file(postfix: stylesheet_postfix, extension: @options[:stylesheet_extension])
          File.open(target_file, 'w') { |f| f.write(content) }
          puts green("Write converted #{target_file}")

          File.delete(source_file)
          puts "Removed #{source_file} in favor of the #{@options[:stylesheet_extension]}"
        end
      end

      def convert_for_asset_pipeline(content)
        # asset URLs
        content.gsub! /\.\.\/font\//, ""
        content.gsub!(/url\(([^\(]+)\)/) do |m|
          $1.include?("application/octet-stream") ? "url(#{$1})" : "font-url(#{$1})"
        end
      end

      def convert_for_webpack(content)
        content.gsub! /\.\.\/font\//, ""
        content.gsub!(/url\(([^\(]+)\)/) do |m|
          replace = if $1[0] == "'"
                      "'~#{$1[1..-1]}"
                    else
                      "~#{$1}"
                    end
          $1.include?("application/octet-stream") ? "url(#{$1})" : "url(#{replace})"
        end
      end

      def sass_enhance(content)
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

        content
      end

      def copy_font_files(zipfile, files)
        puts "font files:"
        files.select{ |file| file.to_s.end_with?(".eot", ".woff", ".woff2", ".ttf", ".svg") }.each do |file|
          filename = file.to_s.split("/").last

          target_file = File.join @options[:font_dir], filename
          zipfile.extract(file, target_file) { true }
          puts green("Copied #{target_file}")
        end
      end

      def copy_config_json(zipfile, config_file)
        puts "config file:"
        zipfile.extract(config_file, @options[:config_file]) { true }
        puts green("Copied #{@options[:config_file]}")
      end

      def copy_stylesheets(zipfile, files)
        puts "stylesheets:"
        files.select{ |file| file.to_s.end_with?('.css') }.each do |file|
          filename = file.to_s.split("/").last

          # extract stylesheet to target location
          target_file = File.join @options[:stylesheet_dir], filename
          zipfile.extract(file, target_file) { true }
          puts green("Copied #{target_file}")
        end
      end

      def copy_icon_guide(zipfile, demo_file)
        puts "icon guide (demo.html):"

        zipfile.extract(demo_file, icon_guide_target_file) { true }
        puts green("Copied #{icon_guide_target_file}")
      end

      def convert_icon_guide
        content = File.read(icon_guide_target_file)
        File.open(icon_guide_target_file, 'w') do |f|
          f.write convert_icon_guide_html(content)
        end
        puts green("Converted demo.html for asset pipeline: #{icon_guide_target_file}")
      end

      def convert_icon_guide_html(content)
        content.gsub! /css\//, "#{@options[:assets_prefix_css]}/"
        content.gsub! "url('./font\/", "url('#{@options[:assets_prefix_fonts]}/"
      end

      def config_file_exists?
        if @options[:config_file] && File.exist?(@options[:config_file])
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

      def icon_guide_target_file
        @_icon_guide_target_file ||= File.join(@options[:icon_guide_dir], "fontello-demo.html")
      end

      def stylesheet_file(postfix: '', extension: '.css')
        if fontello_name.present? && @options[:stylesheet_dir].present?
          File.join(@options[:stylesheet_dir], "#{fontello_name}#{postfix}#{extension}")
        end
      end

      def fontello_name
        @_fontello_name ||= if config_file_exists?
          JSON.parse(File.read(@options[:config_file]))['name'].presence || 'fontello'
        end
      end
  end
end
