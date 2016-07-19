module Toptranslation
  class TranslationList
    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/translations/#{ identifier }")
      Toptranslation::Translation.new(@connection, result)
    end
  end
end
