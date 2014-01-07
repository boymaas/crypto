module ApplicationHelper
  def bitcoin n
    number = n
    unit = 'B'
    precision = 7
    # if n < 1e-6
    #   number *= 1e9
    #   precision = 0
    #   unit = 'e-9'
    # elsif n < 1e-3
    #   number *= 1e6
    #   precision = 2
    #   unit = 'e-6'
    if n < 1e0
      number *= 1e3
      precision = 5
      unit = 'mB'
    end
    number = number_to_currency number, precision: precision, :unit => ''
    n,d = number.split('.')
    d ||= ""
    d += "0" * ( precision - d.length )
    "%d<span class='text-muted'>.%s</span>%s".html_safe % [n.to_i, d, unit]
  end

  # NOTE: make rounding more intelligent for the eye
  def quantity n
    number_to_currency n, precision: 4, :unit => ''
  end

  def system_info
    controller.system_info
  end
  def data_provider
    controller.data_provider
  end
  def cache_key
    controller.cache_key
  end
end
