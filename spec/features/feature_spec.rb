describe "In order to use public transport" do
  it "I want money on my card" do
    oystercard = Oystercard.new
    expect(oystercard.balance).to eq 0
  end
end
