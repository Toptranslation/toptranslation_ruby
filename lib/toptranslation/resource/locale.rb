module Toptranslation::Resource
  class Locale
    attr_reader :name, :code, :custom_code

    def initialize(options = {})
      @options = options
      update_from_response(options)
    end

    private

      def update_from_response(response)
        @code = response['code'] if response['code']
        @name = response['name'] if response['name']
        @custom_code = response['custom_code'] if response['custom_code']
      end
  end
end
