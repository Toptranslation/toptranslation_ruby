module ToptranslationApi
  class ProjectDocumentList < DocumentList
    def create(name, path, options = {})
      response = @connection.post("/projects/#{@options[:project_identifier]}/documents", options.merge(name: name, path: path))
      ToptranslationApi::Document.new(@connection, response)
    end

    def create_batch(documents)
      response = @connection.post("/projects/#{@options[:project_identifier]}/documents/batch", documents: documents)

      response.map { |document_attr| ToptranslationApi::Document.new(@connection, document_attr) }
    end

    private

      def documents
        @connection.get("/projects/#{@options[:project_identifier]}/documents", params: { per_page: 100 })
      end
  end
end
