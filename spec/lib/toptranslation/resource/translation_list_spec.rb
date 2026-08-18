RSpec.describe Toptranslation::Resource::TranslationList do
  let(:connection) { instance_double(Toptranslation::Connection) }

  describe '#each' do
    it 'lists translations of an order via the order_identifier filter' do
      allow(connection).to receive(:get).and_return([{ 'identifier' => 't-1' }])

      list = described_class.new(connection, order_identifier: 'o-1')

      expect(list.map(&:identifier)).to eq ['t-1']
      expect(connection)
        .to have_received(:get)
        .with('/translations', params: { order_identifier: 'o-1' })
    end
  end

  describe '#find' do
    it 'fetches a single translation' do
      allow(connection).to receive(:get).and_return('identifier' => 't-1')

      translation = described_class.new(connection).find('t-1')

      expect(connection).to have_received(:get).with('/translations/t-1')
      expect(translation.identifier).to eq 't-1'
    end
  end
end
