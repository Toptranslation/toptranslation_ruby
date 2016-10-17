module ToptranslationApi
  class ProjectDocumentList < DocumentList
    private
      def documents
        @connection.get("/projects/#{ @options[:project_identifier] }/documents", { per_page: 100 })
      end
  end
end
