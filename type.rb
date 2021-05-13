# frozen_string_literal: true

class CType
  attr_reader :type_name

  def initialize(type)
    @type_name = type
  end

  def info
    "Тип: #{type_name}"
  end
end

class CargoType < CType
  def initialize
    super('CARGO')
  end
end

class PassType < CType
  def initialize
    super('PASS')
  end
end
