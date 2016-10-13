module Toptranslation
  class Upload
    attr_reader :document_store_id, :document_token

    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def upload(filepath)
      response = request(filepath)

      @document_store_id = response['data']['identifier']
      @document_token    = response['data']['document_token']

      self
    end

    def upload_token
      @connection.upload_token ||= request_upload_token
    end

    def request_upload_token
      puts "Requesting upload-token"  if @connection.verbose
      @connection.post('/upload_tokens')['upload_token']
    end

    private

    def request(filepath)
      puts "Uploading: #{ filepath }" if @connection.verbose
      DocumentStoreRequest.post('/documents', :query => {
        file: File.new(filepath, 'r'),
        type: 'document',
        token: upload_token
      })
    end
  end
end
