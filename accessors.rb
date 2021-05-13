# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history = "@#{name}_history".to_sym
      # instance_variable_set(var_history, [])
      define_method("#{name}_history") { instance_variable_get(var_history) }
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        instance_variable_set(var_history, []) if eval("#{var_history}.nil?")
        eval("#{var_history} << #{value}")
      end
    end
  end

  def strong_attr_accessor(name_attr, class_attr)
    name = "@#{name_attr}".to_sym
    define_method(name_attr) { instance_variable_get(name) }
    define_method("#{name_attr}=") do |value|
      raise 'Wrong type' if value.class != class_attr

      instance_variable_set(name, value)
    end
  end
end

class Test
  extend Accessors

  attr_accessor_with_history :my_attr, :a, :b, :c
  strong_attr_accessor :d, Integer
  strong_attr_accessor :f, Array
end
