module Toptranslation::Resource
  class ProjectDocumentList < DocumentList
    def create(name, path, options = {})
      response = @connection.post("/projects/#{@options[:project_identifier]}/documents", options.merge(name: name, path: path))
      Document.new(@connection, response)
    end

    def create_batch(documents)
      response = @connection.post("/projects/#{@options[:project_identifier]}/documents/batch", documents: documents)

      response.map { |document_attr| Document.new(@connection, document_attr) }
    end

    private

      def documents
        params = { per_page: 100 }
        params[:type] = @options[:type] if @options[:type]

        @connection.get("/projects/#{@options[:project_identifier]}/documents", params: params)
      end
  end
end
