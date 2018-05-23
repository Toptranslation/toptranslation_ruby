module ToptranslationApi
  class User
    attr_reader :identifier, :first_name, :last_name, :name

    def initialize(connection, options = {})
      @connection = connection
      @options = options

      update_from_response(options)
    end

    private

      def update_from_response(response)
        @identifier = response['identifier'] if response['identifier']
        @first_name = response['first_name'] if response['first_name']
        @first_name = response['last_name'] if response['last_name']
        @name = response['name'] if response['name']
      end
  end
end
