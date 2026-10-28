RSpec.describe Toptranslation::Resource::Upload do
  subject(:upload) { described_class.new(connection).upload('/a/file/path') }

  let(:connection) { instance_double(Toptranslation::Connection, verbose: false, upload: response) }

  context 'when the document store returns an attach_token' do
    let(:response) do
      { 'identifier' => 'doc-1', 'attach_token' => 'attach-1', 'token' => 'tok-1', 'sha1' => 'abc' }
    end

    it 'prefers the attach_token' do
      expect(upload).to have_attributes(document_store_id: 'doc-1', document_token: 'attach-1', sha1: 'abc')
    end
  end

  context 'when the document store returns only a token' do
    let(:response) { { 'identifier' => 'doc-1', 'token' => 'tok-1', 'sha1' => 'abc' } }

    it 'falls back to the token' do
      expect(upload.document_token).to eq 'tok-1'
    end
  end

  context 'when the document store returns only a document_token' do
    let(:response) { { 'identifier' => 'doc-1', 'document_token' => 'doc-tok-1', 'sha1' => 'abc' } }

    it 'falls back to the document_token' do
      expect(upload.document_token).to eq 'doc-tok-1'
    end
  end
end
