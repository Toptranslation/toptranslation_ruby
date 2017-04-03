module ToptranslationApi
  class ProjectDocumentList < DocumentList
    def create(name, path)
      response = @connection.post("/projects/#{ @options[:project_identifier] }/documents", {name: name, path: path})
      Document.new(@connection, response)
    end

    private

      def documents
        @connection.get("/projects/#{ @options[:project_identifier] }/documents", { per_page: 100 })
      end
  end
end
