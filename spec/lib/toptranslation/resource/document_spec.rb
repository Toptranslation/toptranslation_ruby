RSpec.describe Toptranslation::Resource::Document do
  let(:document) { described_class.new(connection, options) }
  let(:connection) { instance_double(Toptranslation::Connection) }
  let(:response) { instance_double(Hash) }
  let(:download_url) { 'files.toptranslation.com/some_id' }

  let(:options) do
    {
      'identifier' => 'abc',
      'name' => 'test.txt',
      'path' => 'foo/bar',
      'string_count' => 1337,
      'has_missing_strings' => true,
      'updated_at' => '2002-02-03T04:05:06+07:00',
      'created_at' => '2002-02-03T04:05:06+07:00'
    }
  end

  let(:upload) do
    instance_double(
      Toptranslation::Resource::Upload,
      document_store_id: 42,
      document_token: 'abcdefg'
    )
  end
  let(:expected_attributes) do
    {
      identifier: 'abc',
      name: 'test.txt',
      path: 'foo/bar',
      string_count: 1337,
      has_missing_strings: true,
      updated_at: Time.parse('2002-02-03T04:05:06+07:00'),
      created_at: Time.parse('2002-02-03T04:05:06+07:00')
    }
  end

  before do
    allow(connection).to receive(:get).and_return('download_url' => download_url)
    allow(connection).to receive(:post) { options }
    allow(connection).to receive(:patch) { options }
    allow(connection).to receive(:download) { response }
    allow(Toptranslation::Resource::Upload).to receive(:new) { upload }
    allow(Toptranslation::Resource::StringList).to receive(:new)
    allow(upload).to receive(:upload) { upload }
  end

  describe '#initialize' do
    it 'populates all the attr_readers from the options hash' do
      expect(document).to have_attributes(expected_attributes)
    end
  end

  describe '#add_translation' do
    subject(:add_translation) do
      document.add_translation('foo/test.txt', 'de')
    end

    let(:document_options) do
      {
        document_store_id: upload.document_store_id,
        document_token: upload.document_token,
        locale_code: 'de'
      }
    end

    it 'uploads thefile' do
      add_translation
      expect(Toptranslation::Resource::Upload)
        .to have_received(:new)
        .with(connection)
    end

    it 'calls the documents#add_translation API v0' do
      add_translation
      expect(connection)
        .to have_received(:post)
        .with("/documents/#{options['identifier']}/translations", document_options)
    end

    it 'returns the API response' do
      expect(add_translation).to be(options)
    end
  end

  describe '#download' do
    subject(:download) do
      document.download('de', file_format: 'pdf')
    end

    let(:download_options) do
      {
        file_format: 'pdf',
        locale_code: 'de'
      }
    end

    it 'calls the documents#download API v0' do
      download
      expect(connection)
        .to have_received(:get)
        .with("/documents/#{options['identifier']}/download", params: download_options)
    end

    it 'calls connection#download with download_url from documents#download API call' do
      download
      expect(connection)
        .to have_received(:download)
        .with(download_url, String)
    end
  end

  describe '#save' do
    let(:remote_hash) { { name: 'test.txt' } }

    it 'updates the remote document' do
      document.save
      expect(connection)
        .to have_received(:patch)
        .with("/documents/#{options['identifier']}", remote_hash)
    end

    it 'populates all the attr_readers from the response' do
      expect(document.save).to have_attributes(expected_attributes)
    end
  end

  describe '#strings' do
    it 'call StringList.new' do
      document.strings
      expect(Toptranslation::Resource::StringList)
        .to have_received(:new)
        .with(connection, document_identifier: options['identifier'])
    end
  end
end
