require_relative 'train'

class CargoTrain < Train
  def initialize(number)
    super(number, "грузовой")
  end
end