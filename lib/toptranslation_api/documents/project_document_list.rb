module ToptranslationApi
  class ProjectDocumentList < DocumentList
    def create(name, path, options={})
      response = @connection.post("/projects/#{ @options[:project_identifier] }/documents", options.merge({name: name, path: path}))
      Document.new(@connection, response)
    end

    private

      def documents
        @connection.get("/projects/#{ @options[:project_identifier] }/documents", { per_page: 100 })
      end
  end
end
