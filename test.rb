# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    class << self
      attr_reader :validations
    end
    def validations
      @validations ||= []
    end

    def add_validation(validation)
      @validations = validations
      @validations << validation
    end

    def validate(name, method)
      add_validation([name, method])
    end

    def validate_presence(*names)
      names.each do |name|
        add_validation([name, :valid_presence])
      end
    end

    def validate_format(name, format)
      add_validation([name, :valid_format, format])
    end

    def validate_type(name, *types)
      add_validation([name, :valid_type, types])
    end
  end

  module InstanceMethods
    def valid_presence(var_value)
      raise "Attribute can't be nil or empty" if var_value.nil? || (var_value == '')
    end

    def valid_format(var_value, format)
      raise 'Attribute does not match regular expression' if var_value !~ format
    end

    def valid_type(var_value, type)
      raise 'Attribute must be from another class' if type.none? do |x|
                                                        var_value.instance_of?(x)
                                                      end
    end

    def validate!
      self.class.validations.each do |validation|
        name = "@#{validation[0]}".to_sym
        method_name = (validation[1]).to_s.to_sym
        var_value = instance_variable_get(name)

        if validation.length == 2
          send method_name, var_value
        else
          args = validation[2]
          send method_name, var_value, args
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end

# for testing

class Xop
end

class Test
  include Validation

  validate_presence :name, :number
  validate_format :name, /^[\wА-Яа-я]{3}-*[\wА-Яа-я]{2}$/
  validate_type :name, String
  validate :name, :validate_other

  def validate_other(_name)
    puts 'Yes'
  end

  def initialize(name, type)
    @name = name
    @number = 9
    @ttype = type
    validate!
  end
end

# t = Test.new('k', 'o')
