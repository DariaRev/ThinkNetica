# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    class << self
      attr_reader :instances
    end
    def instances
      @instances.nil? ? 0 : @instances
    end

    def register
      @instances = instances + 1
    end
  end

  module InstanceMethods
    def register
      self.class.register
    end
  end
end
