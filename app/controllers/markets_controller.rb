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

    advisor = CryptoTrader::Bot::Advisor::MacdSignalCross.new
    sig_ema_crossing = CryptoTrader::Bot::Signal::EmaCrossing.new

    # NOTE: running advisor on all snapshots
    snapshots = CryptoTrader::Snapshots.new(@market)
    data_points = snapshots.market_trade_stats
    data_points_price_avg = data_points.map {|e| e[1][:price_avg] }

    ema_short   = data_points_price_avg.indicator(:ema, advisor.conf[:short])
    ema_long    = data_points_price_avg.indicator(:ema, advisor.conf[:long])
    data_points = data_points.zip(ema_short.zip(ema_long)).flatten.each_slice(4).to_a

    data = data_points.map do |timestamp, mts, emas, emal|
      snapshot = snapshots.at(timestamp)
      _, bidx = advisor.run_on(snapshot)

      signals = advisor.signals.map do |name, signal|
        [name, signal.run_on(snapshot).to_f]
      end

      ema_crossing = sig_ema_crossing.run_on(snapshot)
      [timestamp * 1000, mts[:price_avg].to_f, mts[:total_sum].to_f, emas.to_f, emal.to_f, bidx, signals]
    end


    # render :json => "callback(#{data.to_json});"
    render :json => data.to_json
  end
end
