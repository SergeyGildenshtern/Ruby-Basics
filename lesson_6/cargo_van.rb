require_relative 'van'

class CargoVan < Van
  attr_reader :total_volume, :available_volume, :occupied_volume

  def initialize(total_volume)
    @type = "грузовой"
    @total_volume = total_volume
    @available_volume = @total_volume
    @occupied_volume = 0
    validate!
  end

  def validate!
    raise "Общий объём не может быть пустым!" if total_volume.nil?
    raise "Общий объём не может быть меньше 1!" if total_volume < 1
  end

  public

  def valid?
    validate!
    true
  rescue
    false
  end

  def take_volume(quantity)
    if quantity > 0 && quantity <= available_volume
      @occupied_volume += quantity
      @available_volume -= quantity
    end
  end
end