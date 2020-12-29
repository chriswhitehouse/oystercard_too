describe "User Story:" do
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
      expect { card.touch_out }.to change { card.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end
  end

  describe "5. In order to get through the barriers" do
    include_context "Card Topped Up"

    it "I need to touch in and out" do
      expect { card.touch_in }.to change { card.in_journey? }.from(false).to(true)
      expect { card.touch_out }.to change { card.in_journey? }.from(true).to(false)
    end
  end

  describe "6. In order to pay for my journey" do
    include_context "Card Empty"

    it "I need to have the minimum amount (£1) for a single journey" do
      expect { card.touch_in }.to raise_error "Insufficient funds"
    end
  end

  describe "7. In order to pay for my journey" do
    include_context "Card Topped Up"

    it "I need to pay for my journey when it's complete" do
      card.touch_in
      expect { card.touch_out }.to change { card.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end
  end
end
