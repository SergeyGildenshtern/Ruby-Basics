require_relative 'modules/instance_counter'
require_relative 'station'

class Route
  include InstanceCounter

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @midterm_stations = []
    validate!
  end

  protected

  def validate!
    raise "Начальная станция не может быть пустой!" if @start_station.nil?
    raise "Конечная станция не может быть пустой!" if @end_station.nil?
    raise "Станции должны быть объектами класса Station!" if @start_station.class != Station || @end_station.class != Station
  end

  public

  def valid?
    validate!
    true
  rescue
    false
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