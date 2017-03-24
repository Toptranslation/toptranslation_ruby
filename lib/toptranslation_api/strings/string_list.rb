module ToptranslationApi
  class StringList
    include Enumerable

    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/strings/#{ identifier }")
      ToptranslationApi::Document.new(@connection, result)
    end

    def each
      strings.each do |string| yield String.new(@connection, string) end
    end

    def create(options={})
      ToptranslationApi::String.new(@connection, options.merge('project_identifier' => @options[:project_identifier], 'document_identifier' => @options[:document_identifier]))
    end

    private

      def strings
        @connection.get("/strings", { params: { project_identifier: @options[:project_identifier], document_identifier: @options[:document_identifier] }})
      end
  end
end