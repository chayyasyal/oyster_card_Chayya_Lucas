require 'station'

describe Station do
  subject(:name) { :name }
  subject(:zone) { :zone }

  subject(:station) { described_class.new(name, zone) }

  it 'has a name' do
    expect(station.name).to eq name
  end

  it 'has a zone' do
    expect([1..6]).to include(station.zone)
  end
end
