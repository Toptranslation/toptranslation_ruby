RSpec.describe Toptranslation::Resource::Order do
  let(:order) { described_class.new(connection, options) }
  let(:connection) { instance_double(Toptranslation::Connection) }

  describe '#add_document' do
    subject(:add_document) { order.add_document(42, 'abc', 'de', ['fr', 'cn']) }

    let(:options) { { 'identifier' => 'foo' } }
    let(:response) { instance_double(Hash) }
    let(:document) { instance_double(Toptranslation::Resource::Document) }

    let(:expected_post_params) do
      {
        document_store_id: 42,
        document_token: 'abc',
        source_locale_code: 'de',
        target_locale_codes: ['fr', 'cn']
      }
    end

    before do
      allow(connection).to receive(:post) { response }
      allow(Toptranslation::Resource::Document).to receive(:new) { document }
    end

    it 'creates the document via the orders documents API v2' do
      add_document
      expect(connection)
        .to have_received(:post)
        .with('/orders/foo/documents', expected_post_params.merge(version: 2))
    end

    it 'creates a document resource' do
      add_document
      expect(Toptranslation::Resource::Document)
        .to have_received(:new)
        .with(connection, response)
    end

    it 'returns the document resource' do
      expect(add_document).to be(document)
    end
  end

  describe '#upload_document' do
    subject(:upload_document) { order.upload_document('/file.pdf', 'de', ['fr', 'cn']) }

    let(:options) { { 'identifier' => 'foo' } }

    let(:upload) do
      instance_double(
        Toptranslation::Resource::Upload,
        document_store_id: 42,
        document_token: 'abcdefg'
      )
    end

    let(:document) { instance_double(Toptranslation::Resource::Document) }

    before do
      allow(Toptranslation::Resource::Upload).to receive(:new) { upload }
      allow(upload).to receive(:upload) { upload }
      allow(order).to receive(:add_document) { document }
    end

    it 'creates an upload resource' do
      upload_document
      expect(Toptranslation::Resource::Upload)
        .to have_received(:new)
        .with(connection)
    end

    it 'uploads the upload resource' do
      upload_document
      expect(upload)
        .to have_received(:upload)
        .with('/file.pdf')
    end

    it 'adds the document' do
      upload_document
      expect(order)
        .to have_received(:add_document)
        .with(42, 'abcdefg', 'de', ['fr', 'cn'])
    end

    it 'returns the document' do
      expect(upload_document).to be(document)
    end
  end

  describe '#documents' do
    subject(:documents) { order.documents }

    let(:options) { { 'identifier' => 'foo' } }
    let(:response) { instance_double(Hash) }

    before do
      allow(connection).to receive(:get) { response }
    end

    it 'fetches all documents via the orders documents API v2' do
      documents
      expect(connection)
        .to have_received(:get)
        .with('/orders/foo/documents', version: 2)
    end

    it 'returns the API response' do
      expect(documents).to be(response)
    end
  end

  describe '#quotes' do
    subject(:quotes) { order.quotes }

    let(:options) do
      {
        'quotes' => [
          {
            'identifier' => 'quote_foo'
          },
          {
            'identifier' => 'quote_bar'
          }
        ]
      }
    end

    let(:quote_foo) { instance_double(Toptranslation::Resource::Quote) }
    let(:quote_bar) { instance_double(Toptranslation::Resource::Quote) }

    it 'maps the quotes from the options to Quote resources and returns them' do
      allow(Toptranslation::Resource::Quote).to receive(:new).with(connection, 'identifier' => 'quote_foo') { quote_foo }
      allow(Toptranslation::Resource::Quote).to receive(:new).with(connection, 'identifier' => 'quote_bar') { quote_bar }
      expect(quotes).to eq([quote_foo, quote_bar])
    end
  end

  describe '#translations' do
    subject(:translations) { order.translations }

    let(:options) { { 'identifier' => 'foo' } }

    let(:translation_list) { instance_double(Toptranslation::Resource::TranslationList) }

    it 'creates a TranslationList resource and returns it' do
      allow(Toptranslation::Resource::TranslationList)
        .to receive(:new)
        .with(connection, order_identifier: 'foo')
        .and_return(translation_list)
      expect(translations).to be(translation_list)
    end
  end

  describe '#creator' do
    subject(:creator) { order.creator }

    let(:options) { { 'creator' => { 'identifier' => 'creator_id' } } }
    let(:user) { instance_double(Toptranslation::Resource::User) }

    it 'creates a user from the options hash and returns it' do
      allow(Toptranslation::Resource::User)
        .to receive(:new)
        .with(connection, 'identifier' => 'creator_id')
        .and_return(user)
      expect(creator).to be(user)
    end
  end

  describe '#save' do
    context 'when identifier is present' do
      let(:options) do
        {
          'identifier' => 'foo',
          'comment' => 'hello'
        }
      end

      let(:response) { { 'comment' => 'bye', 'name' => 'test' } }

      before do
        allow(connection).to receive(:patch) { response }
      end

      it 'updates the order via the orders API v2' do
        order.save
        expect(connection)
          .to have_received(:patch)
          .with('/orders/foo', version: 2, comment: 'hello', coupon_code: nil, delivery_date: nil)
      end

      it 'updates the order from the response' do
        order.comment = 'bye'
        expect { order.save }
          .to change(order, :name)
          .from(nil)
          .to('test')
      end
    end

    context 'when identifier is not present' do
      let(:options) do
        {
          'comment' => 'hello'
        }
      end

      let(:response) { { 'comment' => 'bye', 'name' => 'test' } }

      before do
        allow(connection).to receive(:post) { response }
      end

      it 'creates the order via the orders API v2' do
        order.save
        expect(connection)
          .to have_received(:post)
          .with('/orders', version: 2, comment: 'hello', coupon_code: nil, delivery_date: nil)
      end

      it 'updates the order from the response' do
        order.comment = 'bye'
        expect { order.save }
          .to change(order, :name)
          .from(nil)
          .to('test')
      end
    end
  end

  describe '#request' do
    subject(:request) { order.request }

    let(:options) { { 'identifier' => 'foo' } }
    let(:response) { { 'comment' => 'bar' } }

    before do
      allow(connection).to receive(:patch) { response }
    end

    it 'requests the order via the the request order API v2' do
      request
      expect(connection)
        .to have_received(:patch)
        .with('/orders/foo/request', version: 2)
    end

    it 'updates the order from the response' do
      expect { request }
        .to change(order, :comment)
        .from(nil)
        .to('bar')
    end
  end
end
