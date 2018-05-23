module ToptranslationApi
  class Order
    attr_reader :identifier, :state, :created_at,
                :requested_at, :ordered_at, :estimated_delivery_date,
                :creator_hash, :progress, :order_number
    attr_accessor :name, :reference, :comment, :coupon_code, :service_level, :desired_delivery_date, :quote_required

    def initialize(connection, options = {})
      @connection = connection
      @options = options
      @name = @options[:name]
      @reference = @options[:reference]
      @comment = @options[:comment]
      @coupon_code = @options[:coupon_code]
      @service_level = @options[:service_level]
      @desired_delivery_date = @options[:desired_delivery_date]
      @quote_required = @options[:quote_required]

      update_from_response(options)
    end

    def add_document(document_store_id, document_token, source_locale_code, target_locale_codes)
      response = @connection.post("/orders/#{@identifier}/documents",
                                  document_store_id: document_store_id,
                                  document_token: document_token,
                                  source_locale_code: source_locale_code,
                                  target_locale_codes: target_locale_codes)

      ToptranslationApi::Document.new(@connection, response)
    end

    def upload_document(filepath, source_locale_code, target_locale_codes)
      upload = ToptranslationApi::Upload.new(@connection).upload(filepath)

      add_document(upload.document_store_id, upload.document_token, source_locale_code, target_locale_codes)
    end

    def documents
      @connection.get "orders/#{@identifier}/documents"
    end

    def quotes
      @quotes ||= @options['quotes'].inject([]) do |accu, quote|
        accu << ToptranslationApi::Quote.new(@connection, quote)
      end
    end

    def translations
      ToptranslationApi::TranslationList.new(@connection, order_identifier: @identifier)
    end

    def creator
      @creator ||= ToptranslationApi::User.new(@connection, @options['creator'])
    end

    def save
      response = @identifier ? update_remote_order : create_remote_order
      update_and_return_from_response(response)
    end

    def request
      response = @connection.patch("/orders/#{@identifier}/request")
      update_and_return_from_response(response)
    end

    private

      def update_remote_order
        @connection.patch("/orders/#{@identifier}", remote_hash)
      end

      def create_remote_order
        @connection.post('/orders', remote_hash)
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
        @progress = response['progress_in_percent'] if response['progress_in_percent']
        @order_number = response['order_number'] if response['order_number']
        @service_level = response['service_level'] if response['service_level']
        @desired_delivery_date = response['desired_delivery_date'] if response['desired_delivery_date']
      end

      def remote_hash
        hash = {}
        hash[:reference] = @reference if @reference
        hash[:comment] = @comment if @comment
        hash[:coupon_code] = @coupon_code
        hash[:delivery_date] = @delivery_date
        hash[:name] = @name if @name
        hash[:service_level] = @service_level if @service_level
        hash[:desired_delivery_date] = @desired_delivery_date if @desired_delivery_date
        hash[:quote_required] = @quote_required if @quote_required

        hash
      end
  end
end
