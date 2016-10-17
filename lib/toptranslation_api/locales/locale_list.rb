module ToptranslationApi
  class LocaleList
    include Enumerable

    def initialize(connection, options={})
      @connection = connection
      @options = options
    end

    def find(code)
      result = locales.select do |l| l['code'] == code end.first
      Locale.new(result) if result
    end

    def each
      locales.each do |locale| yield Locale.new(locale) end
    end

    private

    def locales
      @connection.get('/locales')
    end
  end
end
