module ApplicationHelper
  def bitcoin n
    number = n
    unit = 'B'
    precision = 2
    if n < 1e-3
      number *= 1e8
      precision = 0
      unit = 'e-8'
    elsif n < 1e-0
      number *= 1e3
      unit = 'e-3'
    end
    number = number_to_currency number, precision: precision, :unit => ''
    "%s<sup class='text-muted'>%s</sup>".html_safe % [number, unit]
  end

  def quantity n
    number_to_currency n, precision: 2, :unit => ''
  end
end
