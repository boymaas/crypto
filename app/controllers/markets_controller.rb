class MarketsController < SecuredController
  def show
    @account = current_user.crypto_trader_account
    @desired_portfolio = CryptoTrader::Runner::DesiredPortfolio.new(@account)

    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:id))
    @analyzed_market = CryptoTrader::AnalyzedMarket.new(@market)
    @market_state = @analyzed_market.market_state
    @orderbook = @analyzed_market.orderbook
    @buy_orders = @orderbook.buy_orders_with_accumulated_total(:total, :quantity ).map {|h| OpenStruct.new(h)}
    @sell_orders = @orderbook.sell_orders_with_accumulated_total(:total, :quantity ).map {|h| OpenStruct.new(h)}

    @account_trades = data_provider.account_trades :account_id => @account.id, :market_id => @market.id
  end

end
