module Toptranslation
  class ProjectList
    include Enumerable

    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/projects/#{ identifier }")
      Toptranslation::Project.new(@connection, result)
    end

    def create(options={})
      Toptranslation::Project.new(@connection, options)
    end

    def each
      projects.each do |project| yield Project.new(@connection, project) end
    end

    private

    def projects
      @connection.get('/projects')
    end
  end
end
