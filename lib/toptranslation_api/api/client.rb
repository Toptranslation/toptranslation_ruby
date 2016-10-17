module ToptranslationApi
  class Client
    def initialize(options)
      @connection = ToptranslationApi::Connection.new(options)
    end

    def orders(options={})
      @order_list ||= ToptranslationApi::OrderList.new(@connection, options)
    end

    def translations(options={})
      @translation_list ||= ToptranslationApi::TranslationList.new(@connection, options)
    end

    def projects(options={})
      @project_list ||= ToptranslationApi::ProjectList.new(@connection, options)
    end

    def locales(options={})
      @locale_list ||= ToptranslationApi::LocaleList.new(@connection, options)
    end
  end
end
