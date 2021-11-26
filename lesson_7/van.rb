require_relative 'modules/maker'
require_relative 'modules/validation'

class Van
  include Maker
  include Validation

  attr_reader :type
end