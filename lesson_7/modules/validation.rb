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
        value = instance_variable_get(validation[:name])
        case validation[:type]
        when :presence
          raise "Значение атрибута равно nil или пустой строке!" if value.nil? || value.strip.empty?
        when :format
          raise "Значение атрибута не соответствует формату!" if value !~ validation[:param]
        when :type
          raise "Значение атрибута не соответствует классу!" if value.class != validation[:param]
        when :more_zero
          raise "Значение атрибута меньше 1!" if value < 1
        else
          next
        end
      end
    end
  end
end
