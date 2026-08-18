module Toptranslation::Resource
  class DocumentList
    include Enumerable

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def each
      documents.each { |document| yield Document.new(@connection, document) }
    end

    private

      def documents
        @connection.get('/documents')
      end
  end
end
