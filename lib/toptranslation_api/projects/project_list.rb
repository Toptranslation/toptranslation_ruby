module ToptranslationApi
  class ProjectList
    include Enumerable

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/projects/#{identifier}")
      ToptranslationApi::Project.new(@connection, result)
    end

    def create(options = {})
      ToptranslationApi::Project.new(@connection, options)
    end

    def each
      projects.each { |project| yield Project.new(@connection, project) }
    end

    private

      def projects
        @connection.get('/projects')
      end
  end
end
