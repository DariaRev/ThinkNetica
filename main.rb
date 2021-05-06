# frozen_string_literal: true

require_relative 'name'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'car'
require_relative 'route'
require_relative 'station'
require_relative 'type'
# require_relative 'cargo_train'
# require_relative 'pass_train'

class RailRoad
  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def menu
    while TRUE
      puts 'Введите 1, чтобы создать станцию, поезд или маршрут'
      puts 'Введите 2, чтобы сделать операции с созданными объектами'
      puts 'Введите 3, чтобы вывести данные о текущих объектах'
      puts 'Введите 0, чтобы выйти'
      ans = gets.chomp.to_i
      break if ans.zero?

      create_smth if ans == 1
      add_smth if ans == 2
      info(TRUE) if ans == 3
    end
  end

  # это тестовые данные
  def seed
    @stations = [Station.new('s1'), Station.new('s2'), Station.new('s3')]
    @trains = [Train.new(1, CargoType.new), Train.new(2, CargoType.new), Train.new(3, PassType.new)]
    route = Route.new(stations[0], stations[2])
    route.add_station(stations[1])
    @routes = [route]
    trains[0].set_route(route)
  end

  private # пользователь должен работать только через основное меню

  def info(show_trains = FALSE)
    puts 'Список станций:'
    (1..stations.length).each do |i|
      station = @stations[i - 1]
      puts "#{i} - #{station.name}"
      next unless show_trains

      station.trains_now.each do |train|
        puts train.info
      end
    end
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    stations << Station.new(name)
    puts 'Станция создана'
  rescue StandardError => e
    puts e.inspect
  end

  def create_train
    puts 'Тип поезда?'
    puts '1 - грузовой, 2 - пассажирский'
    type = gets.chomp.to_i
    raise 'Ошибка выбора типа' unless [1, 2].include?(type)

    puts 'Введите номер поезда'
    numb = gets.chomp
    puts 'Введите название компании'
    company_name = gets.chomp
    t = Train.new(numb, CargoType.new, company_name) if type == 1
    t = Train.new(numb, PassType.new, company_name) if type == 2
    trains << t
    puts "Поезд #{numb} создан"
  rescue StandardError => e
    puts e.inspect
    retry
  end

  def create_route
    info
    puts 'Введите номер первой станции маршрута'
    r_first = gets.chomp.to_i
    puts 'Введите номер последней станции маршрута'
    r_last = gets.chomp.to_i
    route = Route.new(stations[r_first - 1], stations[r_last - 1])
    @routes << route
  end

  def select_route
    puts 'Выберите номер маршрута'
    info_routes
    numb = gets.chomp.to_i
    route = @routes[numb - 1]
  end

  def route_add_station
    route = select_route
    puts route.info
    puts 'Выберите номер станции, которую хотите добавить'
    info
    st = gets.chomp.to_i
    station = stations[st - 1]
    get_sts = route.get_stations
    if get_sts.include? station
      puts 'Такая станция уже есть в маршруте'
    else
      route.add_station(station)
    end
  end

  def route_del_station
    route = select_route
    puts 'Выберите номер станции, которую хотите удалить'
    route_sts = route.get_stations[1...-1]
    (1..route_sts.length).each do |i|
      station = route_sts[i - 1]
      puts "#{i} - #{station.name}"
    end
    st = gets.chomp.to_i
    deleted_station = route_sts[st - 1]
    route.remove_station(deleted_station)
  end

  def select_train_by_num
    puts 'Номер поезда?'
    numb = gets.chomp
    found = (trains.select { |train| train.number == numb }).first
  end

  def add_car
    found = select_train_by_num
    return if found.nil?

    if found.type.instance_of? CargoType
      car = Car.new(CargoType.new)
    elsif found.type.instance_of? PassType
      car = Car.new(PassType.new)
    end
    found.add_car(car)
  end

  def del_car
    found = select_train_by_num
    return if found.nil?

    found.delete_car
  end

  def move_forward
    found = select_train_by_num
    forward = found.move_forward
    if forward
      puts 'Получилось'
    else
      puts 'Поезд не может двигаться дальше'
    end
  end

  def move_back
    found = select_train_by_num
    back = found.move_back
    if back
      puts 'Получилось'
    else
      puts 'Поезд не может двигаться дальше'
    end
  end

  def set_train_route
    found = select_train_by_num
    route = select_route
    train_route = found.set_route(route)
  end

  def create_smth
    puts '1 - создать станцию'
    puts '2 - создать поезд'
    puts '3 - создать маршрут'
    puts '0 - exit'
    ans = gets.chomp.to_i
    create_station if ans == 1
    create_train if ans == 2
    create_route if ans == 3
  end

  def add_smth
    puts '1 - добавить станцию в маршрут'
    puts '2 - удалить станцию из маршрута'
    puts '3 - добавить вагон к поезду'
    puts '4 - удалить вагон из поезда'
    puts '5 - переместить поезд на станцию вперед'
    puts '6 - переместить поезд на станцию назад'
    puts '7 - назачить маршрут поезду'
    puts '0 - exit'
    ans = gets.chomp.to_i
    route_add_station if ans == 1
    route_del_station if ans == 2
    add_car if ans == 3
    del_car if ans == 4
    move_forward if ans == 5
    move_back if ans == 6
    set_train_route if ans == 7
  end

  def info_routes
    (1..routes.length).each do |i|
      route = @routes[i - 1]
      puts "#{i} - #{route.info}"
    end
  end
end
