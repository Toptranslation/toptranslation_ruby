module Toptranslation
  class Client
    def initialize(options)
      @connection = Connection.new(options)
    end

    def orders(options = {})
      @order_list ||= Resource::OrderList.new(@connection, options)
    end

    def translations(options = {})
      @translation_list ||= Resource::TranslationList.new(@connection, options)
    end

    def projects(options = {})
      @project_list ||= Resource::ProjectList.new(@connection, options)
    end

    def locales(options = {})
      @locale_list ||= Resource::LocaleList.new(@connection, options)
    end
  end
end
