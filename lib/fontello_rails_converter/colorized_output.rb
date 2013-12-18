module FontelloRailsConverter
  # for colorized output
  module ColorizedOutput
    def colorize(text, color_code)
      "\033[#{color_code}m#{text}\033[0m"
    end

    {
      :black => 30,
      :red => 31,
      :green => 32,
      :yellow => 33,
      :blue => 34,
      :magenta => 35,
      :cyan => 36,
      :white => 37
    }.each do |key, color_code|
      define_method key do |text|
        colorize(text, color_code)
      end
    end
  end
end