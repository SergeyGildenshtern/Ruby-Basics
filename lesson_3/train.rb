class Train
  attr_reader :station, :type, :speed, :route, :number, :vans

  protected
  # я установил сеттер speed в protected, чтобы использовались только методы go и stop для изменения скорости поезда
  # я установил сеттер station в protected, чтобы пользователь или классы не могли изменять станцию напрямую
  attr_writer :speed, :station

  public

  def initialize(number, type)
    @number = number
    @type = type
    @vans = []
    @speed = 0
  end

  def go
    self.speed = 100
  end

  def stop
    self.speed = 0
  end

  def attach_van(van)
    @vans << van if speed == 0 && van.type == type
  end

  def detach_van(van)
    @vans.delete(van) if speed == 0
  end

  def route=(route)
    @route = route
    self.station = route.show_stations.first
    station.get_train(self)
  end

  def next_station
    if station && station != route.show_stations.last
      index = route.show_stations.index(station)
      route.show_stations[index + 1]
    end
  end

  def previous_station
    if station && station != route.show_stations.first
      index = route.show_stations.index(station)
      route.show_stations[index - 1]
    end
  end

  def go_next_station
    if next_station
      station.send_train(self)
      self.station = next_station
      station.get_train(self)
    end
  end

  def go_previous_station
    if previous_station
      station.send_train(self)
      self.station = previous_station
      station.get_train(self)
    end
  end
end