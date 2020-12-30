describe Oystercard do
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
      card.touch_in(entry_station_double)
      expect(card).to be_in_journey
    end
  end

  describe "#touch_in" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:touch_in).with(1).argument }

    it "should change in_journey from false to true" do
      expect { card.touch_in(entry_station_double) }.to change { card.in_journey? }.from(false).to(true)
    end

    it "should raise an error if balance is less than minimum fare" do
      card = Oystercard.new
      expect { card.touch_in(entry_station_double) }.to raise_error "Insufficient funds"
    end

    it "should record the entry station" do
      card.touch_in(entry_station_double)
      expect(card.journey.entry_station).to eq entry_station_double
    end

    it "should deduct a penalty charge if no prior exit station" do
      stub_const("Journey::PENALTY_CHARGE", 6)
      allow(journey_double).to receive(:fare).and_return(Journey::PENALTY_CHARGE)
      card.touch_in(entry_station_double)
      expect { card.touch_in(entry_station_double) }.to change { card.balance }.by(-Journey::PENALTY_CHARGE)
    end
  end

  describe "#touch_out" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:touch_out).with(1).argument }

    it "should change in_journey from true to false" do
      allow(journey_double).to receive(:fare).and_return(1)
      card.touch_in(entry_station_double)
      expect { card.touch_out(exit_station_double) }.to change { card.in_journey? }.from(true).to(false)
    end

    it "reduce balance by fare amount" do
      stub_const("Journey::MINIMUM_CHARGE", 1)
      allow(journey_double).to receive(:fare).and_return(Journey::MINIMUM_CHARGE)
      card.touch_in(entry_station_double)
      expect { card.touch_out(exit_station_double) }.to change { card.balance }.by(-Journey::MINIMUM_CHARGE)
    end

    it "records entry station as nil" do
      allow(journey_double).to receive(:fare).and_return(6)
      allow(journey_double).to receive(:entry_station).and_return(nil)
      card.touch_out(exit_station_double)
      card.touch_out(exit_station_double)
      expect(card.journeys.last.entry_station).to eq nil
    end

    it "deducts a penalty charge if no prior entry station" do
      stub_const("Journey::PENALTY_CHARGE", 6)
      allow(journey_double).to receive(:fare).and_return(Journey::PENALTY_CHARGE)
      expect { card.touch_out(exit_station_double) }.to change { card.balance }.by(-Journey::PENALTY_CHARGE)
    end
  end

  describe "#journeys" do
    include_context "Card Topped Up"

    it { is_expected.to respond_to(:journeys) }

    it "should be empty by default" do
      expect(card.journeys).to be_empty
    end

    it "should record a collection of entry and exit station pairs" do
      stub_const("Journey::MINIMUM_CHARGE", 1)
      allow(journey_double).to receive(:fare).and_return(Journey::MINIMUM_CHARGE)
      card.touch_in(entry_station_double)
      card.touch_out(exit_station_double)
      expect(card.journeys).to include journey_double
    end
  end
end
