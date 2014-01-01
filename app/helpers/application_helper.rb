module ApplicationHelper
  def bitcoin n
    number = n
    unit = 'e-0'
    precision = 8
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

  def quantity n
    number_to_currency n, precision: 2, :unit => ''
  end
end
