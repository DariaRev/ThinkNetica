# frozen_string_literal: true

require_relative 'name'
require_relative 'type'
class Car
  include CompanyName

  attr_reader :type

  def initialize(type, company_name = '', capacity)
    @type = type
    @company_name = company_name
    @capacity = capacity
    @cur_capacity = 0
  end

  def info
    "Вагон, тип: #{@type.type_name}, занято: #{get_filled} из #{@capacity}"
  end

  def add(capacity)
    @cur_capacity += capacity
  end

  def get_filled
    @cur_capacity
  end

  def get_free
    @capacity - @cur_capacity
  end
end

class CargoCar < Car
  def initialize(company_name, volume)
    super(CargoType.new, company_name, volume.to_f)
  end

  def add(volume)
    raise "Объем превышает допустимый. Остаток = #{get_free}" if get_free <= volume

    super(volume.to_f)
  end
end

class PassCar < Car
  def initialize(company_name, places)
    super(PassType.new, company_name, places.to_i)
  end

  def add
    raise 'Нет свободных мест в вагоне' if get_free <= 0

    super(1)
  end
end
