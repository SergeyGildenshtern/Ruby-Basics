require_relative 'modules/maker'
require_relative 'modules/instance_counter'

class Train
  include Maker
  include InstanceCounter

  NUMBER_FORMAT = /^[a-я0-9]{3}-?[a-я0-9]{2}$/i

  attr_reader :station, :type, :speed, :route, :number

  protected
  # я установил сеттер speed в protected, чтобы использовались только методы go и stop для изменения скорости поезда
  # я установил сеттер station в protected, чтобы пользователь или классы не могли изменять станцию напрямую
  attr_writer :speed, :station

  public

  @@trains = []
  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def initialize(number, type)
    @number = number
    @type = type
    @vans = []
    @speed = 0
    validate!
    @@trains << self
  end

  protected

  def validate!
    raise "Номер не может быть пустым!" if number.nil?
    raise "Тип не может быть пустым!" if type.nil?
    raise "Недопустимый формат номера!" if number !~ NUMBER_FORMAT
    raise "Недопустимый тип поезда!" if type != "пассажирский" && type != "грузовой"
  end

  public

  def valid?
    validate!
    true
  rescue
    false
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

  def vans(&block)
    if block_given?
      @vans.each { |van| block.call(van) }
    else
      @vans
    end
  end
end