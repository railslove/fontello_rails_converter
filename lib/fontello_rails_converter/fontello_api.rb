require 'rest_client'
require 'json'

module FontelloRailsConverter
  class FontelloApi
    FONTELLO_HOST = "http://fontello.com"

    def initialize(options)
      @config_file = options[:config_file]
      @session_id = options[:fontello_session_id]
    end

    def session_id
      @session_id ||= RestClient.post FONTELLO_HOST, config: File.new(@config_file, 'rb')
    end

    def session_url
      "#{FONTELLO_HOST}/#{session_id}"
    end

    def download_zip_body
      response = RestClient.get "#{session_url}/get"
      response.body
    end
  end
end