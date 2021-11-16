class Station
  def initialize(name)
    @name = name
    @trains = []
  end

  def get_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by(type)
    trains = []
    @trains.each do |train|
      if train.type == type
        trains << train
      end
    end

    return trains
  end

  def count_trains_by(type)
    counter = 0
    @trains.each do |train|
      if train.type == type
        counter += 1
      end
    end

    return counter
  end
end

class Route
  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @midterm_stations = []
  end

  def show_stations
    [@start_station] + @midterm_stations + [@end_station]
  end

  def add_midterm_station(station)
    @midterm_stations << station
  end

  def remove_midterm_station(station)
    @midterm_stations.delete(station)
  end
end

class Train
  attr_accessor :vans_quantity, :station
  attr_reader :type, :speed, :route

  def initialize(number, type, vans_quantity)
    @number = number
    @type = type
    @vans_quantity = vans_quantity
    @speed = 0
  end

  def speed=(value)
    if value >= 0
      @speed = value
    end
  end

  def attach_van
    if self.speed == 0
      self.vans_quantity += 1
    end
  end

  def detach_van
    if self.speed == 0 and self.vans_quantity > 0
      self.vans_quantity -= 1
    end
  end

  def route=(route)
    @route = route
    self.station = route.show_stations[0]
  end

  def next_station
    if station != route.show_stations.last
      index = route.show_stations.index(station)
      route.show_stations[index + 1]
    else
      station
    end
  end

  def previous_station
    if station != route.show_stations.first
      index = route.show_stations.index(station)
      route.show_stations[index - 1]
    else
      station
    end
  end
end