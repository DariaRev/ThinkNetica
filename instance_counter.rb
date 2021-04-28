# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    # в этой функции получились танцы с бубном
    def instances_count
      class_variable_get(:@@instances)
      # @@instances - не работает, не понимаю, почему
    end
  end

  module InstanceMethods
    @@instances = 0
    def register_instance
      @@instances += 1
    end
  end
end
