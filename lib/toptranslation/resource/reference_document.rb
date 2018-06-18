module Toptranslation::Resource
  class ReferenceDocument
    attr_reader :identifier, :filename, :filesize, :mime_type, :comment, :created_at

    def initialize(connection, options = {})
      @connection = connection
      @options = options
      update_from_response(options)
    end

    def download(options = {})
      download_path = if options[:path]
                        options[:path]
                      else
                        tempfile = Tempfile.new
                        temp_path = tempfile.path
                        tempfile.close
                        temp_path
                      end
      @connection.download(download_url, download_path)
    end

    def download_url
      @download_url ||= @connection.get("/reference_documents/#{identifier}/download", version: 2)['download_url']
    end

    private

      def update_from_response(response)
        @identifier = response['identifier'] if response['identifier']
        @filename = response['filename'] if response['filename']
        @filesize = response['filesize'] if response['filesize']
        @mime_type = response['mime_type'] if response['mime_type']
        @comment = response['comment'] if response['comment']
        @created_at = Time.parse(response['created_at']) if response['created_at']
      end
  end
end
