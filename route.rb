# frozen_string_literal: true

class Route
  include InstanceCounter
  attr_reader :other_stations, :first_station, :last_station

  def initialize(first_station, last_station)
    register
    @first_station = first_station
    @last_station = last_station
    @other_stations = []
  end

  def add_station(station)
    @other_stations << station
  end

  def remove_station(station)
    @other_stations.delete(station)
  end

  def get_stations
    [first_station, @other_stations, last_station].flatten
  end

  def info
    sts = []
    get_stations.each { |station| sts << station.name }
    "Описание маршрута: #{sts.join(' - ')}"
  end
end
