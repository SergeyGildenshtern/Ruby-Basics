require_relative 'van'

class CargoVan < Van
  validate :total_volume, :more_zero

  attr_reader :total_volume, :occupied_volume

  def initialize(total_volume)
    @type = "грузовой"
    @total_volume = total_volume
    @occupied_volume = 0
    validate!
  end

  def take_volume(quantity)
    if quantity > 0 && quantity <= available_volume
      @occupied_volume += quantity
    end
  end

  def available_volume
    total_volume - occupied_volume
  end
end