class BacktrackRunsController < ApplicationController
  def index
    @backtrack_runs = CryptoTrader::Model::BacktrackRun.all
  end

  def export
    require 'csv'
    backtrack_runs = CryptoTrader::Model::BacktrackRun.all
    csv_string = CSV.generate do |csv|
      backtrack_runs.each do |btr|
        advisor_conf = btr.parameters[:advisor_conf]
        btr.results.each do |r|
          csv << [
            btr.timestamp.utc, 
            advisor_conf[:long], 
            advisor_conf[:short], 
            advisor_conf[:signal], 
            r.market.label,
            r.buy_count,
            r.sell_count,
            r.resulting_budget
          ]
        end
      end
    end

    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = 'attachment; filename=backtrack_runs.csv'  
    render :text => csv_string
  end
end
