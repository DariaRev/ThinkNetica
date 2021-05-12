# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'train'

class Station
  include InstanceCounter
  include Validation

  attr_reader :trains_now, :name

  validate_presence :name

  def initialize(name)
    @name = name.to_s
    @trains_now = []
    validate!
    register
  end

  def trains_each(&block)
    trains_now.each do |train|
      block.call(train)
    end
  end

  def self.all
    ObjectSpace.each_object(Station).to_a
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
