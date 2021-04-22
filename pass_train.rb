class PassengerTrain < Train
  def initialize(number)
    super(number, 'Пассажирский')
  end

  def add_car(car)
    @cars << car if car.instance_of? PassengerCar
  end

  def delete_car
    @cars.pop
  end
end
