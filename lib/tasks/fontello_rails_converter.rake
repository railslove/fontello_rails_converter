desc "[deprecated] import new zipfile from fontello"
task :import_fontello, [:zipfile] => :environment do |t, args|
  puts "THIS RAKE TASK IS DEPRECATED AND WILL BE REMOVED IN THE NEXT VERSION"

  include FontelloRailsConverter::ColorizedOutput
  require 'zip'

  fontello_zipfile = args[:zipfile]

  if fontello_zipfile.blank?
    puts red("you need to specify the path to your fontello .zip file as an argument\ne.g. `rake import_fontello[\"tmp/fontelo-12345678.zip\"]`")
    next
  elsif !File.exist? fontello_zipfile
    puts red("file #{fontello_zipfile} could not be found")
    next
  end

  # target directories
  target_assets_dir = File.join Rails.root, "vendor", "assets"
  target_stylesheets_dir = File.join target_assets_dir, "stylesheets"
  target_fonts_dir = File.join target_assets_dir, "fonts"
  mkdir_p target_stylesheets_dir
  mkdir_p target_fonts_dir

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

  def convert_demo_html(content)
    content.gsub! /css\//, "/assets/"
  end

  Zip::File.open(args[:zipfile]) do |zipfile|
    zipfile.each do |file|
      filename = file.to_s.split("/").last

      # stylesheets
      if filename.end_with? '.css'
        # extract stylesheet to target location
        target_file = File.join target_stylesheets_dir, "#{filename}.scss"
        zipfile.extract(file, target_file) { true }
        puts green("copied #{target_file}")

        if !filename.end_with? "animation.css", "-ie7.css", "-codes.css", "-ie7-codes.css", "-embedded.css"
          converted_css = convert_main_stylesheet File.read(target_file)
          File.open(target_file, 'w') { |f| f.write(converted_css) }
          puts green("converted #{target_file} for Sass & asset pipeline")
        end

      # font files
      elsif filename.end_with? ".eot", ".woff", ".ttf", ".svg", "config.json"
        target_file = File.join target_fonts_dir, filename
        zipfile.extract(file, target_file) { true }
        puts green("copied #{target_file}")

      # demo.html
      elsif filename == 'demo.html'
        target_file = File.join Rails.root, "public", "fontello-demo.html"
        zipfile.extract(file, target_file) { true }
        puts green("copied #{target_file}")

        converted_html = convert_demo_html File.read(target_file)
        File.open(target_file, 'w') { |f| f.write(converted_html) }
        puts green("converted #{filename}'s HTML for asset pipeline")
      end
    end
  end
end