# frozen_string_literal: true

class Car
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def info
    "Вагон, тип: #{@type.type_name}"
  end
end
