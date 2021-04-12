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

  def change_amount(inc_or_dec)
    @amount_cars += 1 if (speed == 0) && (inc_or_dec == '+')
    @amount_cars -= 1 if (speed == 0) && (inc_or_dec == '-')
    @amount_cars = 0 if @amount_cars < 0
  end

  def set_route(route)
    @route = route.show_stations
    @current_station = 0
    @route[@current_station].add_train(self)
  end

  def move_forward
    if @current_station < @route.length
      @route[@current_station - 1].send_train(self)
      @current_station += 1
      @route[@current_station].add_train(self)
    end
  end

  def move_back
    if current_station != 0
      @route[@current_station].send_train(self)
      @current_station = (@current_station - 1)
      @route[@current_station - 1].add_train(self)
    end
  end

  def get_prev_now_next
    "Предыдущая станция: #{@route[@current_station - 1]}, cейчас: #{@route[@current_station]}, cледующая: #{@route[@current_station + 1]}"
  end
end
