module Toptranslation::Resource
  class TranslationList
    include Enumerable

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/translations/#{identifier}")
      Translation.new(@connection, result)
    end

    def each
      translations.each { |translation| yield Translation.new(@connection, translation) }
    end

    private

      def translations
        @connection.get("/orders/#{@options[:order_identifier]}/translations") if @options[:order_identifier]
      end
  end
end
