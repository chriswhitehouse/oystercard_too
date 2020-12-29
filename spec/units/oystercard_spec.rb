describe Oystercard do
  describe "#add_money" do
    it "should increase balance" do
      expect { subject.add_money(5) }.to change { subject.balance }.by(5)
    end
  end

  describe "#balance" do
    it "should return balance" do
      expect(subject.balance).to eq 0
    end
  end
end
