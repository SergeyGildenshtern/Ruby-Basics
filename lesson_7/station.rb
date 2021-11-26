require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Station
  include InstanceCounter
  include Validation

  validate :name, :presence

  attr_reader :name, :trains

  @@stations = []
  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
  end

  def get_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def trains_by(type)
    @trains.filter { |train| train.type == type }
  end

  def count_trains_by(type)
    trains_by(type).count
  end

  def station_trains(&block)
    @trains.each { |train| block.call(train) } if block_given?
  end
end