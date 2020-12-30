describe JourneyLog do
  let(:entry_station_double) { double :station, name: "Waterloo", zone: 1 }
  let(:exit_station_double) { double :station, name: "City", zone: 1 }
  let(:journey_double) {
    double :journey,
    entry_station: entry_station_double,
    exit_station: exit_station_double,
    start: true,
    finish: nil }
  let(:journey_class_double) { double :journey_class, new: journey_double }
  let(:journey_log) { JourneyLog.new(journey_class_double) }

  describe "#start" do
    it "should start a new journey with an entry station" do
      expect(journey_log.start(entry_station_double)).to include journey_double
    end

    it "should record a journey" do
      journey_log.start(entry_station_double)
      expect(journey_log.journeys).to include journey_double
    end
  end

  describe "#finish" do
    it "should end a journey with an exit station" do
      allow(journey_double).to receive(:complete?).and_return(false)
      journey_log.start(entry_station_double)
      expect( journey_log.finish(exit_station_double) ).to eq nil
    end
  end

  describe "#journeys" do
    it "should return a list of all previous journeys" do
      allow(journey_double).to receive(:complete?).and_return(true)
      journey_log.start(entry_station_double)
      journey_log.finish(exit_station_double)
      expect(journey_log.journeys).to include journey_double
    end
  end

end
