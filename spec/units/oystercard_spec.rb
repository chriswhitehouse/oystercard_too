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

  describe "#deduct" do
    it { is_expected.to respond_to(:deduct).with(1).argument }

    it "should reduce balance by given amount" do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { subject.deduct(5) }.to change { subject.balance }.by(-5)
    end
  end

  describe "#in_journey?" do
    it { is_expected.to respond_to("in_journey?") }

    it "should be false before touch in" do
      expect(subject).not_to be_in_journey
    end
  end

  describe "#touch_in" do
    it { is_expected.to respond_to("touch_in") }

    it "should change in_journey from false to true" do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { subject.touch_in }.to change { subject.in_journey? }.from(false).to(true)
    end

    it "should raise an error if balance is less than minimum fare" do
      expect { subject.touch_in }.to raise_error "Insufficient funds"
    end
  end

  describe "#touch_out" do
    it { is_expected.to respond_to("touch_out") }

    it "should change in_journey from true to false" do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in
      expect { subject.touch_out }.to change { subject.in_journey? }.from(true).to(false)
    end
  end
end
