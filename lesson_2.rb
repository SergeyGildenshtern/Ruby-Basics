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

  def show_trains
    @trains
  end

  def show_trains_statistics
    quantity_passenger_trains = 0
    quantity_freight_trains = 0

    @trains.each do |train|
      if train.type == "грузовой"
        quantity_freight_trains += 1
      else
        quantity_passenger_trains += 1
      end
    end

    [ quantity_freight_trains, quantity_passenger_trains ]
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
  attr_accessor :speed, :vans_quantity
  attr_reader :type

  def initialize(number, type, vans_quantity)
    @number = number
    @type = type
    @vans_quantity = vans_quantity
    @route = nil
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def go
    self.speed = 100
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

  def route
    if @route != nil
      if @station == @route.show_stations.first
        [nil, @route.show_stations.first, @route.show_stations[1]]
      elsif @station == @route.show_stations.last
        [@route.show_stations[-2], @route.show_stations.last, nil]
      else
        index = @route.show_stations.index(@station)
        [@route.show_stations[index - 1], @station, @route.show_stations[index + 1]]
      end
    end
  end

  def route=(route)
    @route = route
    @station = @route.show_stations[0]
  end

  def go_next_station
    if self.route.last != nil
      @station = self.route.last
    end
  end

  def go_previous_station
    if self.route.first != nil
      @station = self.route.first
    end
  end
end