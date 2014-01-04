class MarketTradesController < SecuredController
  def index
    @market  = CryptoTrader::Model::Market[params[:market_id]]
    analyzed_market = CryptoTrader::AnalyzedMarket.new(@market)
    @market_trades = analyzed_market.ordered_desc_trades.extension(:pagination).paginate(params[:page], 40)
  end
end
