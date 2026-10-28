module Toptranslation::Resource
  class Upload
    attr_reader :document_store_id, :document_token, :sha1

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def upload(filepath, type = 'document', &block)
      puts "# Uploading: #{filepath}" if @connection.verbose
      response = @connection.upload(filepath, type, &block)

      @document_store_id = response['identifier']
      # attach_token hat eine längere Anhänge-Frist als token (1 h); ältere
      # Document-Stores liefern nur token bzw. document_token
      @document_token    = response['attach_token'] || response['token'] || response['document_token']
      @sha1              = response['sha1']

      self
    end
  end
end
