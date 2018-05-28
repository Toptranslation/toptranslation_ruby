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
    subject(:download) { connection.download('https://example.com/some-file', 'file-name.pdf') }

    let(:response) { instance_double(RestClient::RawResponse, file: file) }
    let(:file) { instance_double(File) }

    before do
      allow(RestClient::Request).to receive(:execute) { response }
    end

    it 'sends a get for the given url, requesting a raw response' do
      download
      expect(RestClient::Request)
        .to have_received(:execute)
        .with(method: :get, url: 'https://example.com/some-file', raw_response: true)
    end

    it 'returns the file from the raw response' do
      expect(download).to be(file)
    end
  end

  describe '#upload' do
    subject(:upload) { connection.upload('some-file.pdf', 'document_type') }

    let(:response) do
      {
        data: {
          identifier: 'foo'
        }
      }
    end

    let(:token_response) do
      {
        data: {
          upload_token: 'upload_token'
        }
      }
    end

    let(:file) { instance_double(File) }

    before do
      allow(File).to receive(:new) { file }
      allow(RestClient).to receive(:post).with(/files/, Hash) { response.to_json }
      allow(RestClient).to receive(:post) { token_response.to_json }
    end

    it 'opens the file from disk at the given path' do
      upload
      expect(File).to have_received(:new).with('some-file.pdf')
    end

    it 'requests an upload token' do
      upload
      expect(RestClient)
        .to have_received(:post)
        .with('https://api.toptranslation.com/v0/upload_tokens', access_token: 'token')
    end

    it 'sends a post with the to the files api' do
      upload
      expect(RestClient)
        .to have_received(:post)
        .with('https://files.toptranslation.com/documents', file: file, type: 'document_type', token: 'upload_token')
    end

    # it 'returns the data object from the API response' do
    #   expect(upload).to eq(identifier: 'foo')
    # end
  end
end
