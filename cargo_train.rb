class CargoTrain < Train
  def initialize(number)
    super(number, 'Грузовой')
  end

  def add_car(car)
    @cars << car if car.instance_of? CargoCar
  end

  def delete_car
    @cars.pop
  end
end
