class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @exit_station = nil
  end

  def finish(exit_station)
    @exit_station = exit_station
    self
  end

  def fare
    if complete?
      MINIMUM_FARE
    else
      PENALTY_FARE
    end
  end

  def complete?
    if @entry_station != nil && @exit_station != nil
      true
    else
      false
    end
  end
end
