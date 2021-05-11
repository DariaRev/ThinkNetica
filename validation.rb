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
      @validations
    end

    def validate(name, type, *args)
      @validations ||= []
      @validations << [name, type, args]
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        name = "@#{validation[0]}".to_sym
        var_type = (validation[1]).to_s.to_sym
        var_value = instance_variable_get(name)
        args = validation[2]
        if var_type == :presence && (var_value.nil? || (var_value == ''))
          raise "Attribute #{name} can't be nil or empty"
        end
        raise "Attribute #{name} does not match regular expression" if var_type == :format && var_value !~ args[0]
        raise "Attribute #{name} must be from another class" if var_type == :type && args.none? do |x|
                                                                  var_value.instance_of?(x)
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
'''
class Xop
end

class Test
  include Validation

  validate :name, :presence
  validate :name, :type, String
  validate :name, :format, /[A-Za-z]/
  validate :ttype, :presence
  validate :ttype, :type, Xop
  def initialize(name, type)
    @name = name
    @ttype = type
    validate!
  end
end
'''
