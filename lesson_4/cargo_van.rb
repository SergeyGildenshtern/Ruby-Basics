require_relative 'van'

class CargoVan < Van
  def initialize
    @type = "грузовой"
  end
end