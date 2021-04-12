class Station
  attr_reader :trains_heavy, :trains_pas, :trains_now, :name

  def initialize(name)
    @name = name.to_s
    @trains_now = []
  end

  def add_train(train)
    @trains_now << train
  end

  def trains_by_type
    trains_heavy = 0
    trains_pas = 0

    trains_now.each do |train|
      trains_heavy += 1 if train.type == 'Грузовой'
      trains_pas += 1 if train.type == 'Пассажирский'
    end
    puts trains_heavy, trains_pas
  end

  def send_train(train)
    trains_now.delete(train)
  end
end
