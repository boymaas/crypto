class MarketsController < SecuredController
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

    data_avg_price = data.map(&:price_avg)

    ema_24 = data_avg_price.indicator(:ema, 24)
    ema_48 = data_avg_price.indicator(:ema, 48)

    macd_i = data_avg_price.indicator(:macd_24_48_9)
    macd = macd_i[:out_macd]
    macd_s = macd_i[:out_macd_signal]
    macd_h = macd_i[:out_macd_hist]
    # macd_12_26_9[:out_macd_signal]
    # macd_12_26_9[:out_macd_hist]

    # data = [data, ema_24, ema_48, macd].reverse.inject(macd_s) { |d0, d1| d0.zip(d1) }
    data = data.zip(ema_24.zip(ema_48.zip(macd.zip(macd_s.zip(macd_h))))).flatten
    data = data.each_slice(6).map {|d,e1,e2,m,ms,mh| [d.rounded_date.to_i * 1000, d.price_avg.to_f, d.total_sum.to_f, e1.to_f, e2.to_f, m, ms, mh] }

    # render :json => "callback(#{data.to_json});"
    render :json => data.to_json
  end
end
