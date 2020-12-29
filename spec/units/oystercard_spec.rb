describe Oystercard do
  let(:station) { double :station, name: "Waterloo" }

  describe "#balance" do
    include_context "Card Empty"

    it { is_expected.to respond_to(:balance) }

    it "should return balance" do
      expect(card.balance).to eq 0
    end
  end

  describe "#top_up" do
    include_context "Card Empty"

    it { is_expected.to respond_to(:top_up).with(1).argument }

    it "should add money to the balance" do
      expect { card.top_up(5) }.to change { card.balance }.by(5)
    end

    it "should not exceed the balance limit" do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { card.top_up(1) }.to raise_error("Maximum balance of £#{Oystercard::MAXIMUM_BALANCE} exceeded")
    end
  end

  describe "#in_journey?" do
    include_context "Card Empty"

    it { is_expected.to respond_to(:in_journey?) }

    it "should be false before touch in" do
      expect(card).not_to be_in_journey
    end
  end

  describe "#touch_in" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:touch_in).with(1).argument }

    it "should change in_journey from false to true" do
      expect { card.touch_in(station) }.to change { card.in_journey? }.from(false).to(true)
    end

    it "should raise an error if balance is less than minimum fare" do
      card = Oystercard.new
      expect { card.touch_in(station) }.to raise_error "Insufficient funds"
    end

    it "should record the entry station" do
      expect { card.touch_in(station) }.to change { card.entry_station }.from(nil).to(station)
    end
  end

  describe "#touch_out" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:touch_out) }

    it "should change in_journey from true to false" do
      card.touch_in(station)
      expect { card.touch_out }.to change { card.in_journey? }.from(true).to(false)
    end

    it "reduce balance by fare amount" do
      card.touch_in(station)
      expect { card.touch_out }.to change { card.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end

    it "records entry station as nil" do
      card.touch_in(station)
      expect { card.touch_out }.to change { card.entry_station }.from(station).to(nil)
    end
  end

  describe "#station" do
    include_context "Card Empty"

    it { is_expected.to respond_to(:entry_station) }
  end
end
