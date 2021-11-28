require_relative 'train'

class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, "грузовой")
    validate!
    @@trains << self
  end
end