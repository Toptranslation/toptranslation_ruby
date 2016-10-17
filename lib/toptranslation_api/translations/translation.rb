module ToptranslationApi
  class Translation
    attr_reader :identifier, :filename, :filesize, :mime_type, :updated_at, :created_at,
                :progress

    def initialize(connection, options={})
      @connection = connection
      @options = options
      update_from_response(options)
    end

    def reference_documents
      @reference_documents ||= @options['reference_documents'].inject([]) do |accu, reference_document|
        accu << ReferenceDocument.new(@connection, reference_document)
      end
    end

    def download
      @connection.download(download_url, @filename)
    end

    private

    def download_url
      @download_url ||= @connection.get("/translations/#{ identifier }/download")['download_url']
    end

    def update_from_response(response)
      @identifier = response['identifier'] if response['identifier']
      @filename = response['filename'] if response['filename']
      @mime_type = response['mime_type'] if response['mime_type']
      @progress = response['progress_in_percent'] if response['progress_in_percent']
      @updated_at = DateTime.parse(response['updated_at']) if response['updated_at']
      @created_at = DateTime.parse(response['created_at']) if response['created_at']
    end
  end
end
