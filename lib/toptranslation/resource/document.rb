module Toptranslation::Resource
  class Document
    attr_reader :identifier, :string_count, :has_missing_strings, :translations, :updated_at, :created_at, :sha1
    attr_accessor :name, :path

    def initialize(connection, options = {})
      @connection = connection
      update_from_response(options)
    end

    def download_url(locale_code, options = {})
      params = { file_format: options[:file_format], locale_code: locale_code }.compact
      @connection.get("/documents/#{@identifier}/download", params: params)['download_url']
    end

    def download(locale_code, options = {}, &block)
      download_path = if options[:path]
                        options[:path]
                      else
                        tempfile = Tempfile.new
                        temp_path = tempfile.path
                        tempfile.close
                        temp_path
                      end
      @connection.download(download_url(locale_code, options), download_path, &block)
    end

    private

      def update_from_response(response)
        @identifier = response['identifier'] if response['identifier']
        @name = response['name'] if response['name']
        @path = response['path'] if response['path']
        @string_count = response['string_count'] if response['string_count']
        @has_missing_strings = response['has_missing_strings'] if response['has_missing_strings']
        @sha1 = response['sha1'] if response['sha1']
        @updated_at = Time.parse(response['updated_at']) if response['updated_at']
        @created_at = Time.parse(response['created_at']) if response['created_at']
        if response['translations']
          @translations = response['translations'].inject([]) do |accu, translation|
            accu << Translation.new(@connection, translation)
          end
        end
      end

  end
end
