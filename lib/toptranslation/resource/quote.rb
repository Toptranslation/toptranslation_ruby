module Toptranslation::Resource
  class Quote
    attr_reader :identifier, :state, :product, :value, :created_at,
                :estimated_delivery_date

    def initialize(connection, options = {})
      @connection = connection
      @options = options
      update_from_response(options)
    end

    def accept
      @connection.patch("/quotes/#{identifier}/accept")
    end

    def reject(reason = nil)
      @connection.patch("/quotes/#{identifier}/reject", reason: reason)
    end

    private

      def update_from_response(response)
        @identifier = response['identifier'] if response['identifier']
        @state = response['state'] if response['state']
        @product = response['product'] if response['product']
        @value = response['value'] if response['value']
        @estimated_delivery_date = DateTime.parse(response['estimated_delivery_date']) if response['estimated_delivery_date']
        @created_at = DateTime.parse(response['created_at']) if response['created_at']
      end
  end
end
