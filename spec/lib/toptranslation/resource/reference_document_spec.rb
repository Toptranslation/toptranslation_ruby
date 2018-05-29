RSpec.describe Toptranslation::Resource::ReferenceDocument do
  let(:reference_document) { described_class.new(connection, options) }
  let(:connection) { instance_double(Toptranslation::Connection) }

  let(:options) do
    {
      'identifier' => 'foo',
      'filename' => 'important.txt',
      'filesize' => 2048,
      'mime_type' => 'text/plain',
      'comment' => 'This is a comment',
      'created_at' => '2002-02-03T04:05:06+07:00'
    }
  end

  describe '#initialize' do
    let(:expected_attributes) do
      {
        identifier: 'foo',
        filename: 'important.txt',
        filesize: 2048,
        mime_type: 'text/plain',
        comment: 'This is a comment',
        created_at: Time.parse('2002-02-03T04:05:06+07:00')
      }
    end

    it 'populates all the attr_readers from the options hash' do
      expect(reference_document).to have_attributes(expected_attributes)
    end
  end

  describe 'download' do
    subject(:download) { reference_document.download }

    let(:response) { { 'download_url' => 'https://example.com/important.txt' } }
    let(:file) { instance_double(File) }

    before do
      allow(connection).to receive(:get) { response }
      allow(connection).to receive(:download) { file }
    end

    it 'fetches the download url from the reference documents API v2' do
      download
      expect(connection)
        .to have_received(:get)
        .with('/reference_documents/foo/download', version: 2)
    end

    it 'downloads the file' do
      download
      expect(connection)
        .to have_received(:download)
        .with('https://example.com/important.txt')
    end

    it 'returns the downloaded file' do
      expect(download).to be(file)
    end
  end
end
