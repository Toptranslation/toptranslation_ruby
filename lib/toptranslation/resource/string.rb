module Toptranslation::Resource
  class String
    attr_reader :identifier, :updated_at, :created_at
    attr_accessor :value, :state, :project_identifier, :document_identifier, :key, :comment, :context, :array_index, :plural_form, :locale_code

    def initialize(connection, options = {})
      @connection = connection
      @options = options

      update_from_response(options)
    end

    def save
      response = @identifier ? update_remote_string : create_remote_string
      update_and_return_from_response(response)
    end

    private

      def update_remote_string
        @connection.patch("/strings/#{@identifier}", remote_hash)
      end

      def create_remote_string
        @connection.post('/strings', remote_hash)
      end

      def update_and_return_from_response(response)
        if response
          update_from_response(response)
          self
        end
      end

      def update_from_response(response)
        @identifier = response['identifier'] if response['identifier']
        @key = response['key'] if response['key']
        @value = response['value'] if response['value']
        @state = response['state'] if response['state']
        @comment = response['comment'] if response['comment']
        @context = response['context'] if response['context']
        @array_index = response['array_index'] if response['array_index']
        @plural_form = response['plural_form'] if response['plural_form']
        @locale_code = response['locale_code'] if response['locale_code']
        @project_identifier = response['project_identifier'] if response['project_identifier']
        @document_identifier = response['document_identifier'] if response['document_identifier']
        @updated_at = DateTime.parse(response['updated_at']) if response['updated_at']
        @created_at = DateTime.parse(response['created_at']) if response['created_at']
      end

      def remote_hash
        hash = {}
        hash[:key]   = @key   if @key
        hash[:value] = @value if @value
        hash[:state] = @state if @state
        hash[:comment] = @comment if @comment
        hash[:locale_code] = @locale_code if @locale_code
        hash[:plural_form] = @plural_form if @plural_form
        hash[:project_identifier] = @project_identifier if @project_identifier
        hash[:document_identifier] = @document_identifier if @document_identifier
        hash
      end
  end
end
