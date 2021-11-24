require_relative 'van'

class PassengerVan < Van
  attr_reader :seats_quantity, :available_seats_quantity, :occupied_seats_quantity

  def initialize(seats_quantity)
    @type = "пассажирский"
    @seats_quantity = seats_quantity
    @available_seats_quantity = @seats_quantity
    @occupied_seats_quantity = 0
    validate!
  end

  def validate!
    raise "Общее количество мест не может быть пустым!" if seats_quantity.nil?
    raise "Общее количество мест не может быть меньше 1!" if seats_quantity < 1
  end

  public

  def valid?
    validate!
    true
  rescue
    false
  end

  def take_seat
    if occupied_seats_quantity < seats_quantity
      @occupied_seats_quantity += 1
      @available_seats_quantity -= 1
    end
  end
end