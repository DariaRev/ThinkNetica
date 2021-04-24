# frozen_string_literal: true

class Station
  attr_reader :trains_now, :name

  def initialize(name)
    @name = name.to_s
    @trains_now = []
  end

  def add_train(train)
    @trains_now << train
  end

  def send_train(train)
    trains_now.delete(train)
  end

  def trains_by(type)
    trains_now.select { |train| train.type == type }
  end

  def count_trains_by(type)
    trains_by(type).length
  end
end
