# frozen_string_literal: true

class Train
  attr_reader :route, :number, :type, :current_station, :cars, :speed

  def initialize(number, type)
    @number = number.to_s
    @type = type
    @speed = 0
    @cars = []
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
