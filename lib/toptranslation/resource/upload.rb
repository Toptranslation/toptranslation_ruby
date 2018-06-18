module Toptranslation::Resource
  class Upload
    attr_reader :document_store_id, :document_token

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def upload(filepath, type = 'document', &block)
      puts "# Uploading: #{filepath}" if @connection.verbose
      response = @connection.upload(filepath, type, &block)

      @document_store_id = response['identifier']
      @document_token    = response['document_token']

      self
    end
  end
end
