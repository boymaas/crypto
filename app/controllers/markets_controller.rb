class MarketsController < ApplicationController
  def show
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:id))  
    @accounts = CryptoTrader::Model::Account.all
  end

  def data
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:id))  
    data = @market.trade_stats_dataset.order(:rounded_date).all

    data = data.map {|e| [e.rounded_date.to_i * 1000, e.price_avg.to_f, e.total_sum.to_f] }

    # render :json => "callback(#{data.to_json});"
    render :json => data.to_json
  end
end
