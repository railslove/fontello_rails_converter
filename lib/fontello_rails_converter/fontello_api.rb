require 'rest_client'
require 'json'

module FontelloRailsConverter
  class FontelloApi
    FONTELLO_HOST = "https://fontello.com"

    def initialize(options)
      @config_file = options[:config_file]
      @session_id = options[:fontello_session_id]
      @fontello_session_id_file = options[:fontello_session_id_file]
    end

    # creates a new fontello session from config.json
    def new_session_from_config
      @session_id = RestClient.post FONTELLO_HOST, config: File.new(@config_file, 'rb')
      persist_session
      @session_id
    end

    def session_url
      "#{FONTELLO_HOST}/#{session_id}"
    end

    def download_zip_body
      response = RestClient.get "#{session_url}/get"
      response.body.force_encoding("UTF-8")
    end

    private

      def session_id
        @session_id ||= read_or_create_session
      end

      def read_or_create_session
        if @fontello_session_id_file && File.exist?(@fontello_session_id_file)
          @session_id = File.read(@fontello_session_id_file)
          return @session_id  unless @session_id == ""
        end

        new_session_from_config
      end

      def persist_session
        File.open(@fontello_session_id_file, 'w+') { |f| f.write @session_id }
      end
  end
end
