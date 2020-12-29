describe "User Story:" do
  let(:entry_station) { double :station, name: "Waterloo" }
  let(:exit_station) { double :station, name: "City" }
  let(:part_journey) { {:entry_station => entry_station, :exit_station => nil} }
  let(:journey) { {:entry_station => entry_station, :exit_station => exit_station} }

  describe "1. In order to use public transport" do
    include_context "Card Empty"

    it "I want money on my card" do
      expect(card.balance).to eq 0
    end
  end

  describe "2. In order to keep using public transport" do
    include_context "Card Empty"

    it "I want to add money to my card" do
      expect { card.top_up(5) }.to change { card.balance }.by(5)
    end
  end

  describe "3. In order to protect my money" do
    include_context "Card Topped Up"

    it "I don't want to put too much money on my card" do
      expect { card.top_up(1) }.to raise_error("Maximum balance of £#{Oystercard::MAXIMUM_BALANCE} exceeded")
    end
  end

  describe "4. In order to pay for my journey" do
    include_context "Card Topped Up"

    it "I need my fare deducted from my card" do
      card.touch_in(entry_station)
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end
  end

  describe "5. In order to get through the barriers" do
    include_context "Card Topped Up"

    it "I need to touch in and out" do
      expect { card.touch_in(entry_station) }.to change { card.in_journey? }.from(false).to(true)
      expect { card.touch_out(exit_station) }.to change { card.in_journey? }.from(true).to(false)
    end
  end

  describe "6. In order to pay for my journey" do
    include_context "Card Empty"

    it "I need to have the minimum amount (£1) for a single journey" do
      expect { card.touch_in(entry_station) }.to raise_error "Insufficient funds"
    end
  end

  describe "7. In order to pay for my journey" do
    include_context "Card Topped Up"

    it "I need to pay for my journey when it's complete" do
      card.touch_in(entry_station)
      expect { card.touch_out(exit_station) }.to change { card.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end
  end

  describe "8. In order to pay for my journey" do
    include_context "Card Topped Up"

    it "I need to know where I've travelled from" do
      card.touch_in(entry_station)
      expect(card.journeys).to include part_journey
    end
  end

  describe "9. In order to know where I have been" do
    include_context "Card Topped Up"

    it "I want to see to all my previous trips" do
      card.touch_in(entry_station)
      card.touch_out(exit_station)
      expect(card.journeys).to include journey
    end
  end

  describe "10. In order to know how far I have travelled" do
    it "I want to know what zone a station is in" do
      station = Station.new(name: "Waterloo", zone: 1)
      expect(station.name).to eq "Waterloo"
      expect(station.zone).to eq 1
    end
  end
end
