require 'oystercard'
describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }


  describe '#top_up' do
    it '#top_up should change the balance on the Oystercard' do
      expect { oystercard.top_up(10) }.to change { oystercard.balance }.by(10)
    end
  end

  describe '#balance' do
    it '#balance should not exceed £90' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect { oystercard.top_up(90) }.to raise_error('You have exceeded card limit')
    end

    it '#balance should return 0 as a default when Oystercard is initialised' do
      expect(oystercard.balance).to eq Oystercard::DEFAULT_BALANCE
    end
  end

  describe '#tap_in' do
    context 'Card has been topped up and tapped in' do
      before do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        oystercard.tap_in(entry_station)
      end

      it '#card in use' do
        expect(oystercard).to be_in_journey
      end

      it 'remembers the entry station' do
        expect(oystercard.entry_station).to eq entry_station
      end
    end

    it '#tap_in raises error if balance below minimum' do
      expect { oystercard.tap_in(entry_station) }.to raise_error('Insufficient funds')
    end

    it '#creates one journey' do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.tap_in(entry_station)
      subject.tap_out(exit_station)
      expect(oystercard.journey_history.length).to eq 1
    end
  end

  describe '#tap_out' do
    context 'Card has been topped up, tapped in and tapped out' do
      before do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.tap_in(entry_station)
        subject.tap_out(exit_station)
      end
      it '#card not in use' do
        expect(oystercard).to_not be_in_journey
      end

      it 'forgets the entry station' do
        expect(oystercard.entry_station).to eq nil
      end
    end

    context 'Card has been topped and tapped in' do
      before do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.tap_in(entry_station)
      end
      it '#deducts mimumum_balance' do
        expect { oystercard.tap_out(exit_station) }.to change { oystercard.balance }.by(- Oystercard::MINIMUM_BALANCE)
      end
    end

    describe '#journey history' do
      let(:journey){{ entry_station: entry_station, exit_station: exit_station}}

      it '#has no journey history by default' do
        expect(oystercard.journey_history).to be_empty
      end

      it '#will show journey history' do
        subject.top_up Oystercard::MINIMUM_BALANCE
        subject.tap_in(entry_station)
        subject.tap_out(exit_station)
        expect(oystercard.journey_history).to include journey
      end
    end
  end
end
