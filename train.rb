class Train
  attr_accessor :speed
  attr_reader :amount_cars, :route, :number, :type, :current_station

  def initialize(number, type, amount_cars)
    @number = number.to_s
    @type = type
    @amount_cars = amount_cars
    @speed = 0
  end

  def increase_speed(speed)
    self.speed = speed
  end

  def stop
    self.speed = 0
  end

  def add_cars
    @amount_cars += 1 if (speed == 0)
  end
  def delete_cars
    if (speed == 0) && (amount_cars > 0)
      @amount_cars -= 1
    end
  end

  def set_route(route)
    @route = route.get_stations
    @current_station = 0
    @route[@current_station].add_train(self)
  end

  def prev_station
    if @current_station > 0
      @route[@current_station - 1]
    end
  end
  def now_station
    @route[@current_station]
  end
  def next_station
    if @current_station < @route.length - 1
      @route[@current_station + 1]
    end
  end

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
