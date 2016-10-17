module ToptranslationApi
  class Locale
    attr_reader :name, :code

    def initialize(options={})
      @options = options
      update_from_response(options)
    end

    private

    def update_from_response(response)
      @code = response['code'] if response['code']
      @name = response['name'] if response['name']
    end
  end
end
