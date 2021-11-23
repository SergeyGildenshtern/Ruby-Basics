require_relative 'modules/maker'

class Van
  include Maker
  attr_reader :type
end