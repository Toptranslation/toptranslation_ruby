module Toptranslation
  class Connection
    attr_accessor :upload_token, :verbose

    def initialize(options = {})
      @base_url = options[:base_url] || 'https://api.toptranslation.com'
      @files_url = options[:files_url] || 'https://files.toptranslation.com'
      @access_token = options[:access_token] || sign_in(options)
      @verbose = options[:verbose] || false
    end

    def get(path, options = {})
      transform_response(request(:get, path, options), options)
    end

    def post(path, options = {})
      transform_response(request(:post, path, options), options)
    end

    def patch(path, options = {})
      transform_response(request(:patch, path, options), options)
    end

    def download(url)
      puts "# downloading #{url}" if @verbose
      raw = RestClient::Request.execute(method: :get, url: url, raw_response: true)
      raw.file
    end

    def upload(filepath, type)
      response = RestClient.post(
        "#{@files_url}/documents",
        file: File.new(filepath),
        type: type,
        token: upload_token
      )

      transform_response(response, version: 0)
    end

    private

      def version(options)
        options[:version] || 0
      end

      def request(method, path, options)
        url = "#{@base_url}/v#{version(options)}#{path}"
        puts "# #{method}-request #{url}" if @verbose
        puts "options: #{prepare_request_options(options, method)}" if @verbose
        RestClient.send(method, url, prepare_request_options(options, method))
      rescue RestClient::ExceptionWithResponse => e
        puts e.response if @verbose
        raise e
      end

      def upload_token
        @upload_token ||= request_upload_token
      end

      def request_upload_token
        puts '# Requesting upload-token' if @verbose
        token = post('/upload_tokens')['upload_token']
        puts "# Upload-token retrieved: #{token}" if @verbose
        token
      end

      def sign_in(options)
        sign_in_options = {
          email: options[:email],
          password: options[:password],
          application_id: 'pollux'
        }.merge!(options)

        access_token = post('/auth/sign_in', sign_in_options)['access_token']

        puts "# Requested access token #{access_token}" if @verbose

        access_token
      end

      def transform_response(response, options)
        puts response if @verbose
        parsed = JSON.parse(response)
        if version(options) == 2
          parsed
        else
          parsed['data']
        end
      end

      def prepare_request_options(options, method)
        request_options = options.dup
        request_options.delete(:version)
        if %i[post patch].include? method
          request_options.merge(auth_params)
        else
          params = options[:params] || {}
          request_options.merge(params: params.merge(auth_params))
        end
      end

      def auth_params
        { access_token: @access_token }
      end
  end
end
