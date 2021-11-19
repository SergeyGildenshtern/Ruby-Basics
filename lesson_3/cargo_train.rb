require_relative 'train'

class CargoTrain < Train
  def initialize(number)
    super(number, "грузовой")
  end

  def attach_van(van)
    super(van) if van.type == type
  end

  def detach_van(van)
    super(van) if van.type == type
  end
end