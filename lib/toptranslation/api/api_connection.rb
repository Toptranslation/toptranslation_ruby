module Toptranslation
  class ApiConnection
    def initialize(options)
      @access_token = options[:access_token] || sign_in(options)
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
      file = Tempfile.new(filename)

      file
    end

    private

    def request(method, uri, options)
      url = "https://api.tt.gl/v0#{ uri }"
      RestClient.send(method, url, prepare_request_options(options, method))
    end

    def sign_in(options)
      sign_in_options = {
        email: options[:email],
        password: options[:password],
        application_id: 'pollux'
      }.merge!(options)

      post('/auth/sign_in', sign_in_options)['access_token']
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
