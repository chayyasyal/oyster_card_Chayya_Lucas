class Oystercard
  attr_reader :balance, :entry_station, :journey_history

  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1


  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journey_history = []

  end

  def top_up (money)
    fail 'You have exceeded card limit' if @balance + money > MAXIMUM_BALANCE
    @balance += money
  end

  def in_journey?
    !!@entry_station
  end

  def tap_in(station)
    fail 'Insufficient funds' if @balance < MINIMUM_BALANCE
    @entry_station = station
    @journey_history << { entry_station: station, exit_station: nil}
  end

  def tap_out(station)
    deduct MINIMUM_BALANCE
    @entry_station = nil
    @journey_history[-1][:exit_station] = station
  end

private
  def deduct (amount)
    @amount = amount
    @balance -= @amount
  end

end
