RSpec.describe Toptranslation::Connection do
  let(:connection) { described_class.new(access_token: 'token') }

  describe '#get' do
    subject(:get) { connection.get('/foo', params: { bar: 'baz' }) }

    let(:response) do
      {
        data: {
          foo: 'bar'
        }
      }
    end

    before do
      allow(RestClient).to receive(:get) { response.to_json }
    end

    it 'sends a get request to the given path with v0' do
      get
      expect(RestClient)
        .to have_received(:get)
        .with('https://api.toptranslation.com/v0/foo', Hash)
    end

    it 'sends the given params along with access token' do
      get
      expect(RestClient)
        .to have_received(:get)
        .with(String, params: { bar: 'baz', access_token: 'token' })
    end

    it 'returns the data object from the API response' do
      expect(get).to eq('foo' => 'bar')
    end

    context 'when version 2 option is given' do
      subject(:get) { connection.get('/foo', version: 2, params: { bar: 'baz' }) }

      let(:response) { { key: 'value', data: { a: 'b' } } }

      it 'returns the whole JSON response' do
        expect(get).to eq('key' => 'value', 'data' => { 'a' => 'b' })
      end

      it 'sends the get request to the v2 API' do
        get
        expect(RestClient)
          .to have_received(:get)
          .with('https://api.toptranslation.com/v2/foo', params: { bar: 'baz', access_token: 'token' })
      end
    end
  end

  describe '#post' do
    subject(:post) { connection.post('/foo', params: { bar: 'baz' }) }

    let(:response) do
      {
        data: {
          foo: 'bar'
        }
      }
    end

    before do
      allow(RestClient).to receive(:post) { response.to_json }
    end

    it 'sends a post request to the given path with v0' do
      post
      expect(RestClient)
        .to have_received(:post)
        .with('https://api.toptranslation.com/v0/foo', Hash)
    end

    it 'sends the given params as regular params and the auth information as headers' do
      post
      expect(RestClient)
        .to have_received(:post)
        .with(String, params: { bar: 'baz' }, access_token: 'token')
    end

    it 'returns the data object from the API response' do
      expect(post).to eq('foo' => 'bar')
    end

    context 'when version 2 option is given' do
      subject(:post) { connection.post('/foo', version: 2, params: { bar: 'baz' }) }

      let(:response) { { key: 'value', data: { a: 'b' } } }

      it 'returns the whole JSON response' do
        expect(post).to eq('key' => 'value', 'data' => { 'a' => 'b' })
      end

      it 'sends the post request to the v2 API' do
        post
        expect(RestClient)
          .to have_received(:post)
          .with('https://api.toptranslation.com/v2/foo', params: { bar: 'baz' }, access_token: 'token')
      end
    end
  end

  describe '#patch' do
    subject(:patch) { connection.patch('/foo', params: { bar: 'baz' }) }

    let(:response) do
      {
        data: {
          foo: 'bar'
        }
      }
    end

    before do
      allow(RestClient).to receive(:patch) { response.to_json }
    end

    it 'sends a patch request to the given path with v0' do
      patch
      expect(RestClient)
        .to have_received(:patch)
        .with('https://api.toptranslation.com/v0/foo', Hash)
    end

    it 'sends the given params as regular params and the auth information as headers' do
      patch
      expect(RestClient)
        .to have_received(:patch)
        .with(String, params: { bar: 'baz' }, access_token: 'token')
    end

    it 'returns the data object from the API response' do
      expect(patch).to eq('foo' => 'bar')
    end

    context 'when version 2 option is given' do
      subject(:patch) { connection.patch('/foo', version: 2, params: { bar: 'baz' }) }

      let(:response) { { key: 'value', data: { a: 'b' } } }

      it 'returns the whole JSON response' do
        expect(patch).to eq('key' => 'value', 'data' => { 'a' => 'b' })
      end

      it 'sends the patch request to the v2 API' do
        patch
        expect(RestClient)
          .to have_received(:patch)
          .with('https://api.toptranslation.com/v2/foo', params: { bar: 'baz' }, access_token: 'token')
      end
    end
  end

  describe '#download' do
    subject(:download) { connection.download(url, path) }

    let(:url) { 'https://example.com/some-file' }
    let(:path) { '/tmp/foo' }
    let(:http) { instance_double(Net::HTTP) }
    let(:response) { instance_double(Net::HTTPResponse) }
    let(:content_length_response) { instance_double(Net::HTTPResponse) }
    let(:file) { instance_double(File) }
    let(:data) { 'data' }

    before do
      allow(File).to receive(:open) { file }
      allow(file).to receive(:write)
      allow(Net::HTTP).to receive(:start).and_yield(http)
      allow(http).to receive(:request_get).and_yield(response)
      allow(http).to receive(:request_head) { content_length_response }
      allow(response).to receive(:read_body).and_yield(data)
      allow(content_length_response).to receive(:[]).with('content-length').and_return(4)
      allow(content_length_response).to receive(:code).and_return('200')
    end

    it 'yields the download progress and content length' do
      expect { |b| connection.download(url, path, &b) }
        .to yield_successive_args([nil, 4], [4, 4])
    end

    it 'writes the response body to a file at the given path' do
      download
      expect(file).to have_received(:write).with('data')
    end

    it 'returns the file from the raw response' do
      expect(download).to be(file)
    end
  end
end
