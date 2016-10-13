module Toptranslation
  class Upload
    attr_reader :document_store_id, :document_token

    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def upload(filepath, type='document')
      puts "Uploading: #{ filepath }" if @connection.verbose
      response = @connection.upload(filepath, type)

      @document_store_id = response['data']['identifier']
      @document_token    = response['data']['document_token']

      self
    end
  end
end
