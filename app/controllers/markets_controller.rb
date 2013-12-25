class MarketsController < ApplicationController
  def show
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:id))  
    @accounts = CryptoTrader::Model::Account.all
    @analyzed_market = CryptoTrader::AnalyzedMarket.new(@market)
    @market_state = @analyzed_market.market_state
    @buy_orders = @market_state.buy_orders_dataset.reverse_order(:price).all
    @sell_orders = @market_state.sell_orders_dataset.order(:price).all
  end

  def data
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:id))  
    data = @market.trade_stats_dataset.order(:rounded_date).all

    ema_24 = data.map(&:price_avg).indicator(:ema, 24)
    ema_48 = data.map(&:price_avg).indicator(:ema, 48)

    data = data.zip(ema_24.zip(ema_48)).flatten
    data = data.each_slice(3).map {|d,e1,e2| [d.rounded_date.to_i * 1000, d.price_avg.to_f.round(8), d.total_sum.to_f.round(8), e1.to_f.round(8), e2.to_f.round(8)] }

    # render :json => "callback(#{data.to_json});"
    render :json => data.to_json
  end
end
