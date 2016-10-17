module ToptranslationApi
  class DocumentList
    include Enumerable

    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/documents/#{ identifier }")
      ToptranslationApi::Document.new(@connection, result)
    end

    def each
      documents.each do |document| yield Document.new(@connection, document) end
    end

    private
      def documents
        @connection.get("/documents")
      end
  end
end
