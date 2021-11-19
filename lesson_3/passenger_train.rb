require_relative 'train'

class PassengerTrain < Train
  def initialize(number)
    super(number, "пассажирский")
  end

  def attach_van(van)
    super(van) if van.type == type
  end

  def detach_van(van)
    super(van) if van.type == type
  end
end