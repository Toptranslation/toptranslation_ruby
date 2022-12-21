module Toptranslation
  class Connection
    attr_accessor :upload_token, :verbose, :access_token

    def initialize(options = {})
      @base_url = options[:base_url] || 'https://api.toptranslation.com'
      @files_url = options[:files_url] || 'https://files.toptranslation.com'
      @access_token = options[:access_token]
      @verbose = options[:verbose] || false
      sign_in!(options) if @access_token.nil? && options.values_at(:email, :password).all?
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

    def download(url, path, &block)
      puts "# downloading #{url}" if @verbose
      uri = URI.parse(url)
      download_uri(uri, path, &block)
    end

    def upload(filepath, type, &block)
      uri = URI.parse("#{@files_url}/documents")
      file = File.new(filepath)
      upload_file(file, type, uri, &block)
    end

    def sign_in!(options)
      return if @access_token

      sign_in_options = {
        email: options[:email],
        password: options[:password],
        application_id: 'pollux'
      }.merge(options)

      @access_token = post('/auth/sign_in', sign_in_options.merge(version: 2))['access_token']

      puts "# Requested access token #{@access_token}" if @verbose

      @access_token
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
        if [:post, :patch].include? method
          request_options.merge(auth_params)
        else
          params = options[:params] || {}
          request_options.merge(params: params.merge(auth_params))
        end
      end

      def auth_params
        { access_token: @access_token }
      end

      def download_content_length(http, uri)
        sleep_time = 0.5
        attempts = 0
        total = nil

        loop do
          raise 'File not available' if attempts >= 10

          head_response = http.request_head(uri.request_uri)
          total = head_response['content-length'].to_i
          break if head_response.code == '200'

          attempts += 1
          sleep sleep_time
          sleep_time += sleep_time * 0.5
        end

        total
      end

      def download_uri(uri, path)
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          total = download_content_length(http, uri)
          yield nil, total if block_given?

          FileUtils.mkpath(File.dirname(path))
          file = File.open(path, 'w')
          http.request_get(uri.request_uri) do |response|
            response.read_body do |data|
              file.write(data)
              yield data.length, total if block_given?
            end
          end
          file
        end
      end

      def upload_file(file, type, uri)
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Post.new(uri)
          request.set_form({ 'file' => file, 'token' => upload_token, 'type' => type }, 'multipart/form-data')

          http.request(request)
        end

        transform_response(response.body, version: 0)
      end
  end
end
