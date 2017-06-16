module ToptranslationApi
  class Connection
    attr_accessor :upload_token, :verbose

    def initialize(options)
      @base_url = options[:base_url] || 'https://api.toptranslation.com/v0'
      @files_url = options[:files_url] || 'https://files.toptranslation.com'
      @access_token = options[:access_token] || sign_in(options)
      @verbose = options[:verbose] || false
    end

    def get(uri, options={})
      transform_response(request(:get, uri, options))
    end

    def post(uri, options={})
      transform_response(request(:post, uri, options))
    end

    def patch(uri, options={})
      transform_response(request(:patch, uri, options))
    end

    def download(url, filename)
      puts "# downloading #{ url }" if @verbose
      raw = RestClient::Request.execute(method: :get, url: url, raw_response: true)
      raw.file
    end

    def upload(filepath, type)
      response = RestClient.post(
        "#{ @files_url }/documents",
        file: File.new(filepath),
        type: type,
        token: upload_token
      )

      transform_response(response)
    end

    private

      def request(method, uri, options)
        url = "#{ @base_url }#{ uri }"
        puts "# #{ method }-request #{ url }" if @verbose
        puts "options: #{ prepare_request_options(options, method) }" if @verbose
        RestClient.send(method, url, prepare_request_options(options, method))
      rescue RestClient::ExceptionWithResponse => e
        puts e.response if @verbose
      end

      def upload_token
        @upload_token ||= request_upload_token
      end

      def request_upload_token
        puts "# Requesting upload-token"  if @verbose
        token = post('/upload_tokens')['upload_token']
        puts "# Upload-token retrieved: #{ token }" if @verbose
        token
      end

      def sign_in(options)
        sign_in_options = {
          email: options[:email],
          password: options[:password],
          application_id: 'pollux'
        }.merge!(options)

        access_token = post('/auth/sign_in', sign_in_options)['access_token']

        puts "# Requested access token #{ access_token }" if @verbose

        return access_token
      end

      def transform_response(response)
        puts response if @verbose
        JSON.parse(response)['data']
      end

      def prepare_request_options(options, method)
        if [:post, :patch].include? method
          options.merge!( auth_params )
        else
          params = options[:params] || {}
          options.merge!({ params: params.merge!(auth_params) })
        end
      end

      def auth_params
        { access_token: @access_token }
      end
  end
end
