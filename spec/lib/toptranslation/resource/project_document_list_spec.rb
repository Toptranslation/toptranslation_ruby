RSpec.describe Toptranslation::Resource::ProjectDocumentList do
  let(:list) { described_class.new(connection, project_identifier: 'p-1') }
  let(:connection) { instance_double(Toptranslation::Connection) }

  describe '#find' do
    it 'looks the document up scoped to the project' do
      allow(connection).to receive(:get).and_return('identifier' => 'doc-1')

      document = list.find('doc-1')

      expect(connection).to have_received(:get).with('/projects/p-1/documents/doc-1')
      expect(document.identifier).to eq 'doc-1'
    end
  end

  describe '#create' do
    it 'posts name and path to the project documents endpoint' do
      allow(connection).to receive(:post).and_return('identifier' => 'doc-1')

      list.create('de/app.yml', 'config/locales/app.yml')

      expect(connection)
        .to have_received(:post)
        .with('/projects/p-1/documents', name: 'de/app.yml', path: 'config/locales/app.yml')
    end
  end

  describe '#create_batch' do
    it 'posts all documents in one request' do
      allow(connection).to receive(:post).and_return([{ 'identifier' => 'doc-1' }, { 'identifier' => 'doc-2' }])

      documents = list.create_batch([{ name: 'a' }, { name: 'b' }])

      expect(connection)
        .to have_received(:post)
        .with('/projects/p-1/documents/batch', documents: [{ name: 'a' }, { name: 'b' }])
      expect(documents.map(&:identifier)).to eq ['doc-1', 'doc-2']
    end
  end
end
