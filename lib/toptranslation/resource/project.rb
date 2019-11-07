module Toptranslation::Resource
  class Project
    attr_reader :identifier, :created_at, :locales, :source_locale
    attr_accessor :name

    def initialize(connection, options = {})
      @connection = connection
      @options = options

      update_from_response(options)
    end

    def upload_document(filepath, locale_code, options = {}, &block)
      upload = Upload.new(@connection).upload(filepath, &block)

      attr_hash = {
        document_store_id: upload.document_store_id,
        document_token: upload.document_token,
        locale_code: locale_code,
        sha1: upload.sha1
      }

      attr_hash[:path] = options[:path] if options[:path]
      attr_hash[:name] = options[:name] if options[:name]

      response = @connection.post("/projects/#{@identifier}/documents", attr_hash)

      Document.new(@connection, response)
    end

    def documents(options = {})
      options.merge!(project_identifier: @identifier)
      ProjectDocumentList.new(@connection, options)
    end

    def strings
      StringList.new(@connection, project_identifier: @identifier)
    end

    def save
      response = @identifier ? update_remote_project : create_remote_project
      update_and_return_from_response(response)
    end

    private

      def update_remote_project
        @connection.patch("/projects/#{@identifier}", remote_hash)
      end

      def create_remote_project
        @connection.post('/projects', remote_hash)
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
        @locales = response['locales'].inject([]) do |accu, locale_data|
          locale = Locale.new(locale_data)
          @source_locale = locale if locale_data['is_source_locale'] # Set source locale of the project
          accu << locale
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
