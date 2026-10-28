module Toptranslation
  class Connection
    attr_accessor :verbose, :access_token

    API_VERSION = 'v2'.freeze

    def initialize(options = {})
      @base_url = options[:base_url] || 'https://api.toptranslation.com'
      @files_url = options[:files_url] || 'https://files.toptranslation.com'
      @access_token = options[:access_token]
      @verbose = options[:verbose] || false
      sign_in!(options) if @access_token.nil? && options.values_at(:email, :password).all?
    end

    def get(path, options = {})
      transform_response(request(:get, path, options))
    end

    def post(path, options = {})
      transform_response(request(:post, path, options))
    end

    def patch(path, options = {})
      transform_response(request(:patch, path, options))
    end

    def download(url, path, &block)
      puts "# downloading #{url}" if @verbose
      uri = URI.parse(url)
      download_uri(uri, path, &block)
    end

    # Uploads go directly to the document store (castor): the response
    # carries the document token that authorizes further use of the file.
    def upload(filepath, _type = 'document', &block)
      uri = URI.parse("#{@files_url}/v2/documents")
      file = File.new(filepath)
      upload_file(file, uri, &block)
    end

    # @deprecated Email/password sign-in was removed from the Toptranslation
    #   API (authentication moved to the auth service) — the endpoint this
    #   method used no longer exists. Initialize the client with a static
    #   access token instead.
    def sign_in!(_options = {})
      raise Toptranslation::SignInRemovedError,
            'sign_in! with email/password is no longer supported: the Toptranslation API ' \
            'removed POST /v2/auth/sign_in. Initialize the client with a static access ' \
            "token instead: Toptranslation.new(access_token: '...'). Contact " \
            'support@toptranslation.com to obtain a token.'
    end

    private

      def request(method, path, options)
        url = "#{@base_url}/#{API_VERSION}#{path}"
        puts "# #{method}-request #{url}" if @verbose
        puts "options: #{prepare_request_options(options, method)}" if @verbose
        RestClient.send(method, url, prepare_request_options(options, method))
      rescue RestClient::ExceptionWithResponse => e
        puts e.response if @verbose
        raise e
      end

      def transform_response(response)
        puts response if @verbose
        JSON.parse(response)
      end

      def prepare_request_options(options, method)
        request_options = options.dup
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
          # Block-Form schließt die Datei, damit der Inhalt vollständig auf der
          # Platte liegt; zurück kommt wie bisher das File-Objekt
          File.open(path, 'w') do |file|
            http.request_get(uri.request_uri) do |response|
              response.read_body do |data|
                file.write(data)
                yield data.length, total if block_given?
              end
            end
            file
          end
        end
      end

      def upload_file(file, uri)
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          request = Net::HTTP::Post.new(uri)
          # stable per upload (not per attempt): the document store recognizes
          # retries and returns the already created document instead of a duplicate
          request.set_form({ 'file' => file, 'idempotency_key' => SecureRandom.uuid }, 'multipart/form-data')

          http.request(request)
        end

        transform_response(response.body)
      end
  end
end
