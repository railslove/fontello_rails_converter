# encoding: UTF-8

Dir["css/*"].each do |file_path|
  if file_path.start_with? 'css/fontello.css'
    content = File.read file_path

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

    File.open(file_path, 'w') { |f| f.write(content) }
  end
  
  File.rename(file_path, "#{file_path}.scss")  if file_path.end_with?('.css')
end

demo_html_content = File.read 'demo.html'
demo_html_content.gsub! /css\//, "/assets/"
File.open('demo.html', 'w') { |f| f.write(demo_html_content) }

