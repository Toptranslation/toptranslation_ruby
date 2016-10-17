module ToptranslationApi
  class Project
    attr_reader :identifier, :created_at, :locales
    attr_accessor :name

    def initialize(connection, options={})
      @connection = connection
      @options = options

      update_from_response(options)
    end

    def upload_document(filepath, locale_code, options={})
      upload = Upload.new(@connection).upload(filepath)

      attr_hash = {
        document_store_id: upload.document_store_id,
        document_token: upload.document_token,
        locale_code: locale_code
      }

      attr_hash[:path] = options[:path] if options[:path]
      attr_hash[:name] = options[:name] if options[:name]

      response = @connection.post("/projects/#{ @identifier }/documents", attr_hash)
    end

    def documents
      ToptranslationApi::ProjectDocumentList.new(@connection, project_identifier: @identifier)
    end

    def save
      response = @identifier ? update_remote_project : create_remote_project
      update_and_return_from_response(response)
    end

    private

    def update_remote_project
      @connection.patch("/projects/#{ @identifier }", remote_hash)
    end

    def create_remote_project
      @connection.post("/projects", remote_hash)
    end

    def update_and_return_from_response(response)
      if response
        update_from_response(response)
        self
      end
    end

    def update_from_response(response)
      @identifier = response['identifier'] if response['identifier']
      @created_at = DateTime.parse(response['created_at']) if response['created_at']
      @locales = response['locales'].inject([]) do |accu, locale|
        accu << Locale.new(locale)
      end
      @name = response['name'] if response['name']
    end

    def remote_hash
      hash = {}
      hash[:name] = @name if @name
      hash
    end
  end
end