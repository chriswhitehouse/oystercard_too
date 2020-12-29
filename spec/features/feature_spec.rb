describe "In order to use public transport" do
  it "I want money on my card" do
    oystercard = Oystercard.new
    expect { oystercard.add_money(5) }.to change { oystercard.balance }.by(5)
  end
end
