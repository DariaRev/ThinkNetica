# frozen_string_literal: true

class Car
  include CompanyName

  attr_reader :type

  def initialize(type, company_name = '')
    @type = type
    @company_name = company_name
  end

  def info
    "Вагон, тип: #{@type.type_name}"
  end
end
