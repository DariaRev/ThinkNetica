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

  def get_prev
    if @current_station > 0
      @route[@current_station - 1]
    end
  end
  def get_now
    @route[@current_station]
  end
  def get_next
    if @current_station < @route.length - 1
      @route[@current_station + 1]
    end
  end

  def move_forward
    if @current_station < @route.length
      get_now.send_train(self)
      get_next.add_train(self)
      @current_station += 1
    end
  end

  def move_back
    if current_station != 0
      get_now.send_train(self)
      get_prev.add_train(self)
      @current_station -= 1
    end
  end
end
