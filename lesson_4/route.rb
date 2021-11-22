require_relative 'modules/instance_counter'

class Route
  include InstanceCounter

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