class MarketStatesController < ApplicationController
  def index
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:market_id))
    @market_states = @market.states_dataset.reverse_order(:timestamp).all
  end

  def show
    @market = CryptoTrader::Model::Market.find(:id => params.fetch(:market_id))
    @market_state = CryptoTrader::Model::MarketState.find(:id => params.fetch(:id))

    @buy_orders = @market_state.buy_orders_dataset.reverse_order(:price).all
    @sell_orders = @market_state.sell_orders_dataset.order(:price).all
  end
end
