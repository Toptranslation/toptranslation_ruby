RSpec.describe Toptranslation::Resource::OrderList do
  let(:order_list) { described_class.new(connection) }
  let(:connection) { instance_double(Toptranslation::Connection) }

  before do
    allow(connection).to receive(:get) { response }
  end

  describe '#find' do
    subject(:find) { order_list.find('foo') }

    let(:response) { instance_double(Hash) }
    let(:order) { instance_double(Toptranslation::Resource::Order) }

    before do
      allow(Toptranslation::Resource::Order).to receive(:new) { order }
    end

    it 'fetches the order via the orders API v2' do
      find
      expect(connection)
        .to have_received(:get)
        .with('/orders/foo', version: 2)
    end

    it 'creates a new Order from the response' do
      find
      expect(Toptranslation::Resource::Order)
        .to have_received(:new)
        .with(connection, response)
    end

    it 'returns the order' do
      expect(find).to be(order)
    end
  end

  describe '#create' do
    subject(:create) { order_list.create('identifier' => 'foo') }

    let(:order) { instance_double(Toptranslation::Resource::Order) }

    before do
      allow(Toptranslation::Resource::Order).to receive(:new) { order }
    end

    it 'creates a new order from the options hash' do
      create
      expect(Toptranslation::Resource::Order)
        .to have_received(:new)
        .with(connection, 'identifier' => 'foo')
    end

    it 'returns the new order' do
      expect(create).to be(order)
    end
  end

  describe '#each' do
    let(:response) do
      [
        {
          'identifier' => 'a'
        },
        {
          'identifier' => 'b'
        }
      ]
    end

    let(:order_a) { instance_double(Toptranslation::Resource::Order) }
    let(:order_b) { instance_double(Toptranslation::Resource::Order) }

    before do
      allow(Toptranslation::Resource::Order).to receive(:new).with(connection, 'identifier' => 'a') { order_a }
      allow(Toptranslation::Resource::Order).to receive(:new).with(connection, 'identifier' => 'b') { order_b }
    end

    it 'fetches all orders via orders API v2' do
      order_list.each {}
      expect(connection)
        .to have_received(:get)
        .with('/orders', version: 2)
    end

    it 'yields all orders' do
      expect { |b| order_list.each(&b) }.to yield_successive_args(order_a, order_b)
    end
  end
end
