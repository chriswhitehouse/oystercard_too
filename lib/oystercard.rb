class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 1
  PENALTY_CHARGE = 6

  attr_reader :balance, :journeys

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    fail "Maximum balance of £#{MAXIMUM_BALANCE} exceeded" if limit_exceeded?(amount)
    @balance += amount
  end

  def in_journey?
    if @journeys.empty?
      false
    else
      !@journeys.last[:exit_station]
    end
  end

  def touch_in(entry_station)
    fail "Insufficient funds" if @balance < MINIMUM_BALANCE
    if in_journey? then
      deduct(PENALTY_CHARGE)
      @journeys << {entry_station: entry_station, exit_station: "incomplete journey"}
    else
      @journeys << {entry_station: entry_station, exit_station: nil}
    end
  end

  def touch_out(exit_station)
    if !in_journey? then
      deduct(PENALTY_CHARGE)
      @journeys << {entry_station: "incomplete journey", exit_station: exit_station}
    else
      deduct(MINIMUM_CHARGE)
      @journeys.last[:exit_station] = exit_station
    end
  end

  private

  def limit_exceeded?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end
end
