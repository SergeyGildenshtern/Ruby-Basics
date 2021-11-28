require_relative 'van'

class PassengerVan < Van
  validate :seats_quantity, :more_zero

  attr_reader :seats_quantity, :occupied_seats_quantity

  def initialize(seats_quantity)
    @type = "пассажирский"
    @seats_quantity = seats_quantity
    @occupied_seats_quantity = 0
    validate!
  end

  def take_seat
    if occupied_seats_quantity < seats_quantity
      @occupied_seats_quantity += 1
    end
  end

  def available_seats_quantity
    seats_quantity - occupied_seats_quantity
  end
end