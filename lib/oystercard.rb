class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :journey_log

  def initialize(journey_log_class = JourneyLog)
    @balance = 0
    @journey_log = journey_log_class.new
  end

  def top_up(amount)
    fail "Maximum balance of £#{MAXIMUM_BALANCE} exceeded" if limit_exceeded?(amount)
    @balance += amount
  end

  def in_journey?
    if @journey_log.journeys.empty?
      false
    else
      !@journey_log.journeys.last.complete?
    end
  end

  def touch_in(entry_station)
    fail "Insufficient funds" if @balance < MINIMUM_BALANCE

    deduct(@journey_log.journeys.last.fare) if in_journey?

    @journey_log.start(entry_station)

  end

  def touch_out(exit_station)
    @journey_log.finish(exit_station)
    deduct(@journey_log.journeys.last.fare)
  end

  private

  def limit_exceeded?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end
end
