module ToptranslationApi
  class TranslationList
    include Enumerable

    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/translations/#{ identifier }")
      ToptranslationApi::Translation.new(@connection, result)
    end

    def each
      translations.each do |translation| yield ToptranslationApi::Translation.new(@connection, translation) end
    end

    private

    def translations
      if @options[:order_identifier]
        @connection.get("/orders/#{ @options[:order_identifier] }/translations")
      end
    end
  end
end
