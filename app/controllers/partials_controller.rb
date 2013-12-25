class PartialsController < ApplicationController
  layout false
  def navbar_stats
    render 'app/views/shared/_navbar_stats'
  end
end
