class Oystercard
  attr_reader :balance, :entry_station, :journey_history

  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journey_history = []
  end

  def top_up(money)
    raise 'You have exceeded card limit' if @balance + money > MAXIMUM_BALANCE
    @balance += money
  end

  def in_journey?
    !!@entry_station
  end

  def tap_in(station)
    raise 'Insufficient funds' if enough_money?
    @entry_station = station
  end

  def tap_out(station)
    deduct MINIMUM_BALANCE
    @exit_station = station
    add_journey
    @entry_station = nil
  end

  private

  def deduct(amount)
    @amount = amount
    @balance -= @amount
  end

  def enough_money?
    @balance < MINIMUM_BALANCE
  end

  def add_journey
    @journey_history << { entry_station: @entry_station, exit_station: @exit_station }
  end
end
