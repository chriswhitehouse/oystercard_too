describe Station do
  let(:station) { Station.new(name: "Waterloo", zone:  1) }

  describe "#name" do
    it "should return the name of the station" do
      expect(station.name).to eq "Waterloo"
    end
  end

  describe "#zone" do
    it "should return the zone of the station" do
      expect(station.zone).to eq 1
    end
  end
end
