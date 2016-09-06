module Toptranslation
  class ApiConnection
    attr_accessor :upload_token, :verbose

    def initialize(options)
      @base_url = options[:base_url] || 'https://api.toptranslation.com/v0'
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
      Tempfile.new(filename)
    end

    private

    def request(method, uri, options)
      url = "#{ @base_url }#{ uri }"
      puts "#{ method }-request #{ url }" if @verbose
      RestClient.send(method, url, prepare_request_options(options, method))
    end

    def sign_in(options)
      sign_in_options = {
        email: options[:email],
        password: options[:password],
        application_id: 'pollux'
      }.merge!(options)

      access_token = post('/auth/sign_in', sign_in_options)['access_token']

      puts "Requested access token #{ access_token }" if @verbose

      return access_token
    end

    def transform_response(response)
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
