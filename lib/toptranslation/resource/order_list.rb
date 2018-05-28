module Toptranslation::Resource
  class OrderList
    include Enumerable

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/orders/#{identifier}")
      ToptranslationApi::Order.new(@connection, result)
    end

    def create(options = {})
      ToptranslationApi::Order.new(@connection, options)
    end

    def each
      orders.each { |order| yield Order.new(@connection, order) }
    end

    private

      def orders
        @connection.get('/orders')
      end
  end
end
