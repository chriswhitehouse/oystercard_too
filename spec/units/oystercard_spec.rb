describe Oystercard do
  let(:entry_station) { double :station, name: "Waterloo" }
  let(:exit_station) { double :station, name: "City" }
  let(:part_journey) { {:entry_station => entry_station, :exit_station => nil} }
  let(:journey) { {:entry_station => entry_station, :exit_station => exit_station} }

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
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:in_journey?) }

    it "should be false before touch in" do
      expect(card).not_to be_in_journey
    end

    it "should be true after touch in" do
      card.touch_in(entry_station)
      expect(card).to be_in_journey
    end
  end

  describe "#touch_in" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:touch_in).with(1).argument }

    it "should change in_journey from false to true" do
      expect { card.touch_in(entry_station) }.to change { card.in_journey? }.from(false).to(true)
    end

    it "should raise an error if balance is less than minimum fare" do
      card = Oystercard.new
      expect { card.touch_in(entry_station) }.to raise_error "Insufficient funds"
    end

    it "should record the entry station" do
      card.touch_in(entry_station)
      expect(card.journeys).to include part_journey
    end

    it "should deduct a penalty charge if no prior exit station" do
      card.touch_in(entry_station)
      expect { card.touch_in(entry_station) }.to change { card.balance }.by(-Oystercard::PENALTY_CHARGE)
    end
  end

  describe "#touch_out" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:touch_out).with(1).argument }

    it "should change in_journey from true to false" do
      card.touch_in(entry_station)
      expect { card.touch_out(exit_station) }.to change { card.in_journey? }.from(true).to(false)
    end

    it "reduce balance by fare amount" do
      card.touch_in(entry_station)
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end

    it "records entry station as nil" do
      card.touch_in(entry_station)
      card.touch_out(exit_station)
      expect(card.journeys).to include journey
    end

    it "deducts a penalty charge if no prior entry station" do
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Oystercard::PENALTY_CHARGE)
    end
  end

  describe "#journeys" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:journeys) }

    it "should be empty by default" do
      expect(card.journeys).to be_empty
    end

    it "should record a collection of entry and exit station pairs" do
      card.touch_in(entry_station)
      card.touch_out(exit_station)
      expect(card.journeys).to include journey
    end
  end
end
