module Toptranslation
  class ApiClient
    def initialize(options)
      @connection = Toptranslation::ApiConnection.new(options)
    end

    def orders(options={})
      @order_list ||= Toptranslation::OrderList.new(@connection, options)
    end

    def locales(options={})
      @locale_list ||= Toptranslation::LocaleList.new(@connection, options)
    end
  end
end
