module Toptranslation
  class ApiClient
    def initialize(options)
      puts Toptranslation::VERSION if options[:verbose]
      @connection = Toptranslation::ApiConnection.new(options)
    end

    def orders(options={})
      @order_list ||= Toptranslation::OrderList.new(@connection, options)
    end

    def translations(options={})
      @translation_list ||= Toptranslation::TranslationList.new(@connection, options)
    end

    def projects(options={})
      @project_list ||= Toptranslation::ProjectList.new(@connection, options)
    end

    def locales(options={})
      @locale_list ||= Toptranslation::LocaleList.new(@connection, options)
    end
  end
end
