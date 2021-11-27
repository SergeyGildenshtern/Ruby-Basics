module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validations
      @validations || []
    end

    def validations=(value)
      @validations = validations << value
    end

    def validate(name, type, param = nil)
      var_name = "@#{name}".to_sym
      self.validations = { name:var_name, type:type, param:param }
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue RuntimeError
      false
    else
      true
    end

    protected
    def validate!
      self.class.validations.each do |validation|
        send("validate_#{validation[:type]}", instance_variable_get(validation[:name]), validation[:param])
      end
    end

    def validate_presence(value, param = nil)
      raise "Значение атрибута равно nil или пустой строке!" if value.nil? || value.strip.empty?
    end

    def validate_format(value, param = nil)
      raise "Значение атрибута не соответствует формату!" if value !~ param
    end

    def validate_type(value, param = nil)
      raise "Значение атрибута не соответствует классу!" if value.class != param
    end

    def validate_more_zero(value, param = nil)
      raise "Значение атрибута меньше 1!" if value < 1
    end
  end
end
