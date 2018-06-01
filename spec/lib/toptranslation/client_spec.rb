RSpec.describe Toptranslation::Client do
  let(:client) { described_class.new(options) }
  let(:options) { {} }
  let(:connection) { instance_double(Toptranslation::Connection) }

  before do
    allow(Toptranslation::Connection).to receive(:new) { connection }
  end

  describe '#initialize' do
    it 'creates a connection' do
      client
      expect(Toptranslation::Connection)
        .to have_received(:new)
        .with(options)
    end
  end

  shared_examples 'list resource' do |method_name, resource_name|
    describe "##{method_name}" do
      subject(:get_list) { client.send(method_name, options) }

      let(:list_resource) { Object.const_get("Toptranslation::Resource::#{resource_name}") }
      let(:list) { instance_double(list_resource) }

      before do
        allow(list_resource).to receive(:new) { list }
      end

      it "creates a #{resource_name} resource" do
        get_list
        expect(list_resource)
          .to have_received(:new)
          .with(connection, options)
      end

      it "returns the #{resource_name} resource" do
        expect(get_list).to be(list)
      end
    end
  end

  include_examples 'list resource', 'orders', 'OrderList'
  include_examples 'list resource', 'translations', 'TranslationList'
  include_examples 'list resource', 'projects', 'ProjectList'
  include_examples 'list resource', 'locales', 'LocaleList'
end
