RSpec.describe Toptranslation::Resource::Quote do
  let(:quote) { described_class.new(connection, options) }
  let(:connection) { instance_double(Toptranslation::Connection) }

  let(:options) do
    {
      'identifier' => 'abc',
      'state' => 'started',
      'product' => 'foo',
      'value' => 1337,
      'estimated_delivery_date' => '2001-02-03T04:05:06+07:00',
      'created_at' => '2002-02-03T04:05:06+07:00'
    }
  end

  let(:response) { instance_double(Hash) }

  before do
    allow(connection).to receive(:patch) { response }
  end

  describe '#initialize' do
    let(:expected_attributes) do
      {
        identifier: 'abc',
        state: 'started',
        product: 'foo',
        value: 1337,
        estimated_delivery_date: Time.parse('2001-02-03T04:05:06+07:00'),
        created_at: Time.parse('2002-02-03T04:05:06+07:00')
      }
    end

    it 'populates all the attr_readers from the options hash' do
      expect(quote).to have_attributes(expected_attributes)
    end
  end

  describe '#accept' do
    subject(:accept) { quote.accept }

    it 'calls the quotes accept API v2' do
      accept
      expect(connection)
        .to have_received(:patch)
        .with('/quotes/abc/accept', version: 2)
    end

    it 'returns the API response' do
      expect(accept).to be(response)
    end
  end

  describe '#reject' do
    subject(:reject) { quote.reject('bar') }

    it 'calls the quotes reject API v2' do
      reject
      expect(connection)
        .to have_received(:patch)
        .with('/quotes/abc/reject', reason: 'bar', version: 2)
    end

    it 'returns the API response' do
      expect(reject).to be(response)
    end
  end
end
