module ToptranslationApi
  class Document
    attr_reader :identifier, :string_count, :has_missing_strings, :translations, :updated_at, :created_at
    attr_accessor :name, :path

    def initialize(connection, options={})
      @connection = connection
      @options = options

      update_from_response(options)
    end

    def add_translation(filepath, locale_code, options={})
      upload = Upload.new(@connection).upload(filepath)

      response = @connection.post("/documents/#{ @identifier }/translations", options.merge({
        document_store_id: upload.document_store_id,
        document_token: upload.document_token,
        locale_code: locale_code,
      }))
    end

    def download(locale_code, file_format = nil)
      params = { file_format: file_format, locale_code: locale_code }.compact
      @connection.get("/documents/#{@identifier}/download", params: params)
    end

    def save
      response = @identifier ? update_remote_document : create_remote_document
      update_and_return_from_response(response)
    end

    def strings
      ToptranslationApi::StringList.new(@connection, document_identifier: @identifier)
    end

    private

      def update_remote_document
        @connection.patch("/documents/#{ @identifier }", remote_hash)
      end

      def create_remote_document
        @connection.post("/documents", remote_hash)
      end

      def update_and_return_from_response(response)
        if response
          update_from_response(response)
          self
        end
      end

      def update_from_response(response)
        @identifier = response['identifier'] if response['identifier']
        @name = response['name'] if response['name']
        @path = response['path'] if response['path']
        @string_count = response['string_count'] if response['string_count']
        @has_missing_strings = response['has_missing_strings'] if response['has_missing_strings']
        @updated_at = DateTime.parse(response['updated_at']) if response['updated_at']
        @created_at = DateTime.parse(response['created_at']) if response['created_at']
        if response['translations']
          @translations = response['translations'].inject([]) do |accu, translation|
            accu << Translation.new(@connection, translation)
          end
        end
      end

      def remote_hash
        hash = {}
        hash[:name] = @name if @name
        hash
      end
  end
end
