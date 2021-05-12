# frozen_string_literal: true

require_relative 'station'
require_relative 'instance_counter'

class Route
  include InstanceCounter
  include Validation
  attr_reader :other_stations, :first_station, :last_station

  validate_type :first_station, Station
  validate_type :last_station, Station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @other_stations = []
    validate!
    register
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
