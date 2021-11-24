require_relative 'modules/instance_counter'

class Station
  include InstanceCounter

  attr_reader :name

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

  protected

  def validate!
    raise "Имя не может быть пустым!" if name.nil?
    raise "Имя не может быть меньше 1 символа!" if name.size < 1
  end

  public

  def valid?
    validate!
    true
  rescue
    false
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

  def trains(&block)
    if block_given?
      @trains.each { |train| block.call(train) }
    else
      @trains
    end
  end
end