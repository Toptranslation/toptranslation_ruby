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
      'updated_at' => '2002-02-03T04:05:06+07:00',
      'created_at' => '2002-02-03T04:05:06+07:00'
    }
  end

  let(:expected_attributes) do
    {
      identifier: 'abc',
      name: 'test.txt',
      path: 'foo/bar',
      updated_at: Time.parse('2002-02-03T04:05:06+07:00'),
      created_at: Time.parse('2002-02-03T04:05:06+07:00')
    }
  end

  before do
    allow(connection).to receive(:get).and_return('download_url' => download_url)
    allow(connection).to receive(:download) { response }
  end

  describe '#initialize' do
    it 'populates all the attr_readers from the options hash' do
      expect(document).to have_attributes(expected_attributes)
    end

    it 'wraps nested translations' do
      nested = described_class.new(connection, options.merge('translations' => [{ 'identifier' => 't-1' }]))
      expect(nested.translations.first).to be_a(Toptranslation::Resource::Translation)
      expect(nested.translations.first.identifier).to eq 't-1'
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

    it 'calls the documents download endpoint' do
      download
      expect(connection)
        .to have_received(:get)
        .with("/documents/#{options['identifier']}/download", params: download_options)
    end

    it 'calls connection#download with download_url from the API call' do
      download
      expect(connection)
        .to have_received(:download)
        .with(download_url, String)
    end
  end
end
