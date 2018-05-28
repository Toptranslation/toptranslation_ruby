module Toptranslation::Resource
  class LocaleList
    include Enumerable

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def find(code)
      result = locales.select { |l| l['code'] == code }.first
      Locale.new(result) if result
    end

    def each
      locales.each { |locale| yield Locale.new(locale) }
    end

    private

      def locales
        @connection.get('/locales', version: 2)
      end
  end
end
