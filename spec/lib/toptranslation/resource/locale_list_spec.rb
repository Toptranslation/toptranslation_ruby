RSpec.describe Toptranslation::Resource::LocaleList do
  let(:locale_list) { described_class.new(connection) }
  let(:connection) { instance_double(Toptranslation::Connection) }
  let(:response) { [{ 'code' => 'de' }, { 'code' => 'fr' }] }

  before do
    allow(connection).to receive(:get) { response }
  end

  describe '.find' do
    subject(:find) { locale_list.find('de') }

    before do
      allow(Toptranslation::Resource::Locale).to receive(:new)
    end

    it 'fetches all locales via the locales API v2' do
      find
      expect(connection).to have_received(:get).with('/locales', version: 2)
    end

    it 'returns a Locale built from the result' do
      locale = instance_double(Toptranslation::Resource::Locale)
      allow(Toptranslation::Resource::Locale).to receive(:new).with('code' => 'de') { locale }
      expect(find).to be(locale)
    end

    context 'when the locale could not be found' do
      it { is_expected.to be_nil }
    end
  end

  describe '.each' do
    let(:locale_de) { instance_double(Toptranslation::Resource::Locale) }
    let(:locale_fr) { instance_double(Toptranslation::Resource::Locale) }

    before do
      allow(Toptranslation::Resource::Locale).to receive(:new).with('code' => 'de') { locale_de }
      allow(Toptranslation::Resource::Locale).to receive(:new).with('code' => 'fr') { locale_fr }
    end

    it 'yields all locales' do
      expect { |b| locale_list.each(&b) }.to yield_successive_args(locale_de, locale_fr)
    end
  end
end
