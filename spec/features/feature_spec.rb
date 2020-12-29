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
end
