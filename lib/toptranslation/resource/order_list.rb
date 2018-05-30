module Toptranslation::Resource
  class OrderList
    include Enumerable

    def initialize(connection, options = {})
      @connection = connection
      @options = options
    end

    def find(identifier)
      result = @connection.get("/orders/#{identifier}", version: 2)
      Order.new(@connection, result)
    end

    def create(options = {})
      Order.new(@connection, options)
    end

    def each
      orders.each { |order| yield Order.new(@connection, order) }
    end

    private

      def orders
        @connection.get('/orders', version: 2)
      end
  end
end
