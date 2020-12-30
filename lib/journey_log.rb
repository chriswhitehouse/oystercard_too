class JourneyLog
  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @journeys = []
  end

  def start(entry_station)
    @current_journey = @journey_class.new(entry_station)
    @journeys << @current_journey
  end

  def finish(exit_station)
    current_journey.finish(exit_station)
    @current_journey = nil
  end

  def journeys
    @journeys.dup
  end

  private

  def current_journey
    @current_journey ||= @journey_class.new
  end
end
