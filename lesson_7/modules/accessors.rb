module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(var_name).last }
        define_method("#{name}=".to_sym) do |value|
          if instance_variable_get(var_name).nil?
            instance_variable_set(var_name, [value])
          else
            instance_variable_set(var_name, instance_variable_get(var_name) << value)
          end
        end
        define_method("#{name}_history".to_sym) { instance_variable_get(var_name) }
      end
    end

    def strong_attr_accessor(name, attribute_class)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value) if value.class == attribute_class
      end
    end
  end
end

