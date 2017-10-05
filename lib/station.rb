class Station
  attr_reader :name

  def initialize(name, zone)
    @name = name
    @zone = zone
  end

  def zone
    [1..6].sample
  end
end
