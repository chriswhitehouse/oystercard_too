class JourneyLog
  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @current_journey = nil
    @journeys = []
  end

  def start(entry_station)
    @current_journey = @journey_class.new(entry_station)
  end

  def finish(exit_station)
    @current_journey.finish(exit_station)
    @journeys << @current_journey
    @current_journey = nil
  end

  def journeys
    @journeys.map do |journey|
      "#{journey}"
    end.join("\n")
  end

  private

  def current_journey
    if !!@current_journey
      @current_journey
    else
      @current_journey = @journey_class.new
    end
  end
end
