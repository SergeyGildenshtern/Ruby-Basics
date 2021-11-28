require_relative 'train'

class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super(number, "пассажирский")
    validate!
    @@trains << self
  end
end