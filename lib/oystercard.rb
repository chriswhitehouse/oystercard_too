class Oystercard
  attr_reader :balance

  def initialize
    @balance = 0
  end

  def add_money(amount)
    @balance += amount
  end
end
