require 'rest_client'
require 'json'

module FontelloRailsConverter
  class FontelloApi
    FONTELLO_HOST = "http://fontello.com"

    def initialize(options)
      @config_file = options[:config_file]
    end

    def session_id
      @session_id ||= RestClient.post FONTELLO_HOST, config: File.new(@config_file, 'rb')
    end

    def session_url
      "#{FONTELLO_HOST}/#{session_id}"
    end

    def download_zip
      resp = RestClient.get "#{session_url}/get"
    end
  end
end