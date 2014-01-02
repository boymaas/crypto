class MarketsController < SecuredController
  def show
    @account = current_user.crypto_trader_account
    @desired_portfolio = CryptoTrader::Runner::DesiredPortfolio.new(@account)

    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:id))  
    @analyzed_market = CryptoTrader::AnalyzedMarket.new(@market)
    @market_state = @analyzed_market.market_state
    @orderbook = @analyzed_market.orderbook
    @buy_orders = @market_state.buy_orders_dataset.reverse_order(:price).all
    @sell_orders = @market_state.sell_orders_dataset.order(:price).all
  end

  def data
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:id))  

    advisor = CryptoTrader::Bot::Advisor::MacdSignalCross.new

    data = cache [:market_chart_data, system_info.last_data_collector_run.id, @market.id] do
      # NOTE: running advisor on all snapshots
      snapshots = CryptoTrader::Snapshots.new(@market)
      snapshots = CryptoTrader::CachedSnapshots.new(snapshots)

      data_points = snapshots.market_trade_stats
      data_points_price_avg = data_points.map {|e| e[1][:price_avg] }

      ema_short   = data_points_price_avg.indicator(:ema, advisor.conf[:short])
      ema_long    = data_points_price_avg.indicator(:ema, advisor.conf[:long])
      data_points = data_points.zip(ema_short.zip(ema_long)).flatten.each_slice(4).to_a

      data = data_points.map do |timestamp, mts, emas, emal|
        snapshot = snapshots.at(timestamp)
        _, bidx = advisor.run_on(snapshot)

        signals = advisor.signals.map do |name, signal|
          [name.to_s.camelcase, signal.run_on(snapshot).to_f]
        end

        [timestamp * 1000, mts[:price_avg].to_f, mts[:total_sum].to_f, emas.to_f, emal.to_f, bidx, signals]
      end
    end


    # render :json => "callback(#{data.to_json});"
    render :json => data.to_json
  end
end
