class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :journey, :journeys

  def initialize(journey_class = Journey)
    @balance = 0
    @journey_class = journey_class
    @journeys = []
    @journey = nil
  end

  def top_up(amount)
    fail "Maximum balance of £#{MAXIMUM_BALANCE} exceeded" if limit_exceeded?(amount)
    @balance += amount
  end

  def in_journey?
    !!@journey
  end

  def touch_in(entry_station)
    fail "Insufficient funds" if @balance < MINIMUM_BALANCE

    deduct(@journey.fare) if in_journey?

    @journey = @journey_class.new(entry_station)

  end

  def touch_out(exit_station)
    @journey = @journey_class.new if !in_journey?

    @journey.finish(exit_station)
    deduct(@journey.fare)
  end

  private

  def limit_exceeded?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
    log_journey
  end

  def log_journey
    @journeys << @journey
    @journey = nil
  end
end
