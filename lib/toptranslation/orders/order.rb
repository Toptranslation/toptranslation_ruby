module Toptranslation
  class Order
    attr_reader :identifier, :state, :created_at,
                :requested_at, :ordered_at, :estimated_delivery_date,
                :creator_hash
    attr_accessor :name, :reference, :comment, :coupon_code

    def initialize(connection, options={})
      @connection = connection
      @options = options

      update_from_response(options)
    end

    def add_document(filepath, source_locale_code, target_locale_codes)
      upload = Upload.new(@connection).upload(filepath)

      response = @connection.post("/orders/#{ identifier }/documents", {
        document_store_id: upload.document_store_id,
        document_token: upload.document_token,
        locale_code: source_locale_code,
        target_locale_codes: target_locale_codes
      })

      update_from_response(response)
    end

    def quotes
      @quotes ||= @options['quotes'].inject([]) do |accu, quote|
        accu << Quote.new(@connection, quote)
      end
    end

    def translations
      @translations ||= @options['translations'].inject([]) do |accu, translation|
        accu << Translation.new(@connection, translation)
      end
    end

    def creator
      @creator ||= Toptranslation::User.new(@connection, @options['creator'])
    end

    def save
      response = @identifier ? update_remote_order : create_remote_order
      update_and_return_from_response(response)
    end

    def request
      response = @connection.patch("/orders/#{ @identifier }/request")
      update_and_return_from_response(response)
    end

    private

    def update_remote_order
      @connection.patch("/orders/#{ @identifier }", remote_hash)
    end

    def create_remote_order
      @connection.post("/orders", remote_hash)
    end

    def update_and_return_from_response(response)
      if response
        update_from_response(response)
        self
      end
    end

    def update_from_response(response)
      @identifier = response['identifier'] if response['identifier']
      @state = response['state'] if response['state']
      @created_at = DateTime.parse(response['created_at']) if response['created_at']
      @ordered_at = DateTime.parse(response['ordered_at']) if response['ordered_at']
      @estimated_delivery_date = DateTime.parse(response['estimated_delivery_date']) if response['estimated_delivery_date']
      @name = response['name'] if response['name']
      @reference = response['reference'] if response['reference']
      @comment = response['comment'] if response['comment']
    end

    def remote_hash
      hash = {}
      hash[:reference] = @reference if @reference
      hash[:comment] = @comment if @comment
      hash[:coupon_code] = @coupon_code
      hash[:delivery_date] = @delivery_date
      hash
    end
  end
end
