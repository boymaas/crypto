class MarketStatesController < SecuredController
  def index
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:market_id))
    @market_states = @market.states_dataset.reverse_order(:timestamp).extension(:pagination).paginate(params[:page], 40)
  end

  def show
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:market_id))
    @market_state = CryptoTrader::Model::MarketState.find(:id => params.fetch(:id))

    @orderbook = CryptoTrader::Orderbook.new(@market_state)

    @buy_orders = @orderbook.buy_orders_with_accumulated_total(:total, :quantity ).map {|h| OpenStruct.new(h)}
    @sell_orders = @orderbook.sell_orders_with_accumulated_total(:total, :quantity ).map {|h| OpenStruct.new(h)}
  end
end
