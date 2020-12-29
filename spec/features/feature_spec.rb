describe "User Story:" do
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
    it "I don't want to put too much money on my card" do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { card.top_up(1) }.to raise_error("Maximum balance of £#{Oystercard::MAXIMUM_BALANCE} exceeded")
    end
  end

  describe "4. In order to pay for my journey" do
    it "I need my fare deducted from my card" do
      card.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { card.deduct(5) }.to change { card.balance }.by(-5)
    end
  end
end
