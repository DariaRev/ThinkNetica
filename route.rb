class Route
  attr_reader :other_stations, :first_station, :last_station

  def initialize(first_station, last_station)
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

  def show_stations
    all_stations = []
    all_stations << first_station
    all_stations << @other_stations
    all_stations << last_station
    all_stations.flatten
  end
end
