describe Oystercard do
  describe "#balance" do
    it { is_expected.to respond_to(:balance) }
    it "should return balance" do
      expect(subject.balance).to eq 0
    end
  end

  describe "#top_up" do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it "should add money to the balance" do
      expect { subject.top_up(5) }.to change { subject.balance }.by(5)
    end

    it "should not exceed the balance limit" do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { subject.top_up(1) }.to raise_error("Maximum balance of £#{Oystercard::MAXIMUM_BALANCE} exceeded")
    end
  end
end
