describe Journey do
  let(:station) { double :station, zone: 1}

  it "knows if a journey is not complete" do
    expect(subject).not_to be_complete
  end

  it 'has a penalty fare by default' do
    expect(subject.fare).to eq Journey::PENALTY_FARE
  end

  it "returns itself when exiting a journey" do
    expect(subject.finish(station)).to eq(subject)
  end

  context 'given an entry station' do
    subject {described_class.new(station)}

    it 'has an entry station' do
      expect(subject.entry_station).to eq station
    end

    it "returns a penalty fare if no exit station given" do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end

    context 'given an exit station' do
      let(:other_station) { double :station, zone: 1 }
      let(:z2_station) { double :station, zone: 2 }
      let(:z3_station) { double :station, zone: 3 }
      let(:z4_station) { double :station, zone: 4 }

      it 'calculates a fare for z1 to z1' do
        subject.finish(other_station)
        expect(subject.fare).to eq 1
      end

      it 'calculates a fare for z1 to z2' do
        subject.finish(z2_station)
        expect(subject.fare).to eq 2
      end

      it "knows if a journey is complete" do
        subject.finish(other_station)
        expect(subject).to be_complete
      end
    end
  end
end
