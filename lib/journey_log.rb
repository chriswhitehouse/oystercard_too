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
    if @journeys.empty?
      @journeys << current_journey.finish(exit_station)
    elsif @journeys.last.complete?
      @journeys << current_journey.finish(exit_station)
    else
      @journeys.last.finish(exit_station)
    end

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
