describe "User Story:" do
  let(:entry_station) { Station.new(name: "Waterloo", zone: 1) }
  let(:exit_station) { Station.new(name: "City", zone: 1) }
  let(:journey) { Journey.new(entry_station) }
  let(:card) { Oystercard.new }

  describe "1. In order to use public transport" do
    it "I want money on my card" do
      expect(card.balance).to eq 0
    end
  end

  describe "2. In order to keep using public transport" do
    it "I want to add money to my card" do
      expect { card.top_up(5) }.to change { card.balance }.by(5)
    end
  end

  describe "3. In order to protect my money" do
    before do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
    end

    it "I don't want to put too much money on my card" do
      expect { card.top_up(1) }.to raise_error("Maximum balance of £#{Oystercard::MAXIMUM_BALANCE} exceeded")
    end
  end

  describe "4. In order to pay for my journey" do
    before do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
    end

    it "I need my fare deducted from my card" do
      card.touch_in(entry_station)
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Journey::MINIMUM_FARE)
    end
  end

  describe "5. In order to get through the barriers" do
    before do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
    end

    it "I need to touch in and out" do
      expect { card.touch_in(entry_station) }.to change { card.in_journey? }.from(false).to(true)
      expect { card.touch_out(exit_station) }.to change { card.in_journey? }.from(true).to(false)
    end
  end

  describe "6. In order to pay for my journey" do
    it "I need to have the minimum amount (£1) for a single journey" do
      expect { card.touch_in(entry_station) }.to raise_error "Insufficient funds"
    end
  end

  describe "7. In order to pay for my journey" do
    before do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
    end

    it "I need to pay for my journey when it's complete" do
      card.touch_in(entry_station)
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Journey::MINIMUM_FARE)
    end
  end

  describe "8. In order to pay for my journey" do
    before do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
    end

    it "I need to know where I've travelled from" do
      card.touch_in(entry_station)
      expect(card.journey_log.journeys.last.entry_station).to eq entry_station
    end
  end

  describe "9. In order to know where I have been" do
    before do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
      journey.finish(exit_station)
    end

    it "I want to see to all my previous trips" do
      card.touch_in(entry_station)
      card.touch_out(exit_station)
      expect(card.journey_log.journeys.last.entry_station).to eq entry_station
      expect(card.journey_log.journeys.last.exit_station).to eq exit_station
    end
  end

  describe "10. In order to know how far I have travelled" do
    it "I want to know what zone a station is in" do
      expect(entry_station.name).to eq "Waterloo"
      expect(entry_station.zone).to eq 1
    end
  end

  describe "11. In order to be charged correctly" do
    before do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
    end

    it "I need a penalty charge deducted if I fail to touch in" do
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Journey::PENALTY_FARE)
    end

    it "I need a penalty charge deducted if I fail to touch out" do
      card.touch_in(entry_station)
      expect { card.touch_in(entry_station) }.to change { card.balance }.by(-Journey::PENALTY_FARE)
    end
  end
end
