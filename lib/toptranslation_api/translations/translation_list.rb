module ToptranslationApi
  class TranslationList
    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/translations/#{ identifier }")
      ToptranslationApi::Translation.new(@connection, result)
    end
  end
end
