RSpec.describe Toptranslation::Connection do
  let(:connection) { described_class.new(access_token: 'token') }

  describe '#get' do
    subject(:get) { connection.get('/foo', params: { bar: 'baz' }) }

    let(:response) { { key: 'value', data: { a: 'b' } } }

    before do
      allow(RestClient).to receive(:get) { response.to_json }
    end

    it 'sends a get request to the v2 API' do
      get
      expect(RestClient)
        .to have_received(:get)
        .with('https://api.toptranslation.com/v2/foo', Hash)
    end

    it 'sends the given params along with access token' do
      get
      expect(RestClient)
        .to have_received(:get)
        .with(String, params: { bar: 'baz', access_token: 'token' })
    end

    it 'returns the whole JSON response' do
      expect(get).to eq('key' => 'value', 'data' => { 'a' => 'b' })
    end
  end

  describe '#post' do
    subject(:post) { connection.post('/foo', params: { bar: 'baz' }) }

    let(:response) { { key: 'value' } }

    before do
      allow(RestClient).to receive(:post) { response.to_json }
    end

    it 'sends a post request to the v2 API' do
      post
      expect(RestClient)
        .to have_received(:post)
        .with('https://api.toptranslation.com/v2/foo', Hash)
    end

    it 'sends the given params as regular params and the auth information as headers' do
      post
      expect(RestClient)
        .to have_received(:post)
        .with(String, params: { bar: 'baz' }, access_token: 'token')
    end

    it 'returns the whole JSON response' do
      expect(post).to eq('key' => 'value')
    end
  end

  describe '#patch' do
    subject(:patch) { connection.patch('/foo', params: { bar: 'baz' }) }

    let(:response) { { key: 'value' } }

    before do
      allow(RestClient).to receive(:patch) { response.to_json }
    end

    it 'sends a patch request to the v2 API' do
      patch
      expect(RestClient)
        .to have_received(:patch)
        .with('https://api.toptranslation.com/v2/foo', Hash)
    end

    it 'sends the given params as regular params and the auth information as headers' do
      patch
      expect(RestClient)
        .to have_received(:patch)
        .with(String, params: { bar: 'baz' }, access_token: 'token')
    end

    it 'returns the whole JSON response' do
      expect(patch).to eq('key' => 'value')
    end
  end

  describe '#upload' do
    subject(:upload) { connection.upload(file_path) }

    let(:file_path) do
      file = Tempfile.new
      file.write('content')
      file.close
      file.path
    end
    let(:http) { instance_double(Net::HTTP) }
    let(:http_response) { instance_double(Net::HTTPResponse, body: { identifier: 'doc-1', token: 'tok-1' }.to_json) }
    let(:request) { instance_double(Net::HTTP::Post) }

    before do
      allow(Net::HTTP).to receive(:start).and_yield(http)
      allow(Net::HTTP::Post).to receive(:new) { request }
      allow(request).to receive(:set_form)
      allow(http).to receive(:request) { http_response }
    end

    it 'posts the file to the document store v2 endpoint' do
      upload
      expect(Net::HTTP::Post).to have_received(:new) do |uri|
        expect(uri.to_s).to eq 'https://files.toptranslation.com/v2/documents'
      end
    end

    it 'sends the file with an idempotency key' do
      upload
      expect(request).to have_received(:set_form) do |form, type|
        expect(form['file']).to be_a(File)
        expect(form['idempotency_key']).to be_a(String)
        expect(type).to eq 'multipart/form-data'
      end
    end

    it 'returns the parsed document store response' do
      expect(upload).to eq('identifier' => 'doc-1', 'token' => 'tok-1')
    end
  end

  describe '#sign_in!' do
    it 'raises with guidance — email/password sign-in was removed from the API' do
      expect { connection.sign_in!(email: 'a@b.c', password: 'secret') }
        .to raise_error(Toptranslation::SignInRemovedError, /static access\s?token/i)
    end

    it 'also raises when initializing with email and password' do
      expect { described_class.new(email: 'a@b.c', password: 'secret') }
        .to raise_error(Toptranslation::SignInRemovedError)
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
      allow(File).to receive(:open).and_yield(file)
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
