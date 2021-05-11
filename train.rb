# frozen_string_literal: true

require_relative 'name'
require_relative 'instance_counter'
require_relative 'car'
require_relative 'type'
require_relative 'validation'

class Train
  include CompanyName
  include InstanceCounter
  include Validation

  attr_reader :route, :number, :type, :current_station, :cars, :speed

  validate :number, :presence
  validate :number, :format, /^[\wА-Яа-я]{3}-*[\wА-Яа-я]{2}$/
  validate :type, :type, CargoType, PassType
  validate :company_name, :presence

  def initialize(number, type, company_name = '')
    @number = number.to_s
    @type = type
    @speed = 0
    @company_name = company_name
    @cars = []
    validate!
    register
  end

  def cars_each(&block)
    @cars.each { |car| block.call(car) }
  end

  def self.find(number)
    ObjectSpace.each_object(Train).each do |t|
      return t if t.number == number.to_s
    end
    nil
  end

  def add_car(car)
    @cars << car if car.type.instance_of?(@type.class)
  end

  def delete_car
    @cars.pop
  end

  def info
    "Поезд #{@number}, тип: #{@type.type_name}, вагонов: #{cars.length}"
  end

  # public потому что нам не важно, какой это поезд
  # может стать private, если будут методы, связанные с движением
  # но сейчас мы скорость никак не регулируем, поэтому эти методы явно пока лишние
  def increase_speed(speed)
    self.speed = speed
  end

  def stop
    self.speed = 0
  end

  # все остальные публичные, потому что мы обращаемся к методам снаружи
  def set_route(route)
    @route = route.get_stations
    @current_station = 0
    @route[@current_station].add_train(self)
  end

  # три следующих метода могли бы стать приватными, если бы в задании не было сказано
  # "Возвращать предыдущую станцию, текущую, следующую, на основе маршрута"
  def prev_station
    @route[@current_station - 1] if @current_station.positive?
  end

  def now_station
    @route[@current_station]
  end

  def next_station
    @route[@current_station + 1] if @current_station < @route.length - 1
  end

  # public, потому что мы можем управлять поездом вперед и назад
  def move_forward
    if next_station
      now_station.send_train(self)
      next_station.add_train(self)
      @current_station += 1
    end
  end

  def move_back
    if prev_station
      now_station.send_train(self)
      prev_station.add_train(self)
      @current_station -= 1
    end
  end
end
