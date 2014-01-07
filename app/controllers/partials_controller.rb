class PartialsController < ApplicationController
  layout false

  # TODO: make cache_id dependable on accounts last bot run 
  #       and nav_stats should be on both
  def navbar_stats
    render :json => {
      :cache_id => rand*1000,
      :data => render_to_string(:partial => 'shared/navbar_stats')
    }
  end

  # TODO: meta-program this stuff into a configurable object
  def bot_run_actions
    cache_id =  params.fetch(:cache_id, 0)
    if cache_id == '0' or cache_id == cache_key.server_state_for_account
      return render :json => {:cache_id => cache_key.server_state_for_account}
    end

    market_id = params.fetch(:market_id, nil) 
    market_id &&= market_id.to_i # <== important 
    render :json => {
      :cache_id => cache_key.server_state_for_account,
      :data => cache( [ :bot_run_actions, cache_key.server_state_for_account ] ) do
        render_to_string :partial => 'shared/bot_run_actions', :locals => {
          :bot_run_actions => data_provider.bot_run_actions(:market_id => market_id)
        }
      end
    }
  end

  def account_trades
    cache_id =  params.fetch(:cache_id, 0)
    if cache_id == '0' or cache_id == cache_key.server_state_for_account
      return render :json => {:cache_id => cache_key.server_state_for_account}
    end

    market_id = params.fetch(:market_id, nil) 
    market_id &&= market_id.to_i # <== important 
    render :json => {
      :cache_id => cache_key.server_state_for_account,
      :data => cache( [ :account_trades, cache_key.server_state_for_account ] ) do
        render_to_string :partial => 'shared/account_trades', :locals => {
          :account_trades => data_provider.account_trades(:market_id => market_id)
        }
      end
    }
  end

  def accounts_positions
    cache_id =  params.fetch(:cache_id, 0)
    if cache_id == '0' or cache_id == cache_key.server_state_for_account
      return render :json => {:cache_id => cache_key.server_state_for_account}
    end

    render :json => {
      :cache_id => cache_key.server_state_for_account,
      :data => cache( [ :accounts_positions, cache_key.server_state_for_account ] ) do
        market_data_provider = CryptoTrader::MarketDataProvider.new()
        account_data_provider = CryptoTrader::AccountDataProvider.new(data_provider.current_crypto_trader_account)
        portfolio = CryptoTrader::Portfolio.new(account_data_provider, market_data_provider)

        render_to_string :partial => 'accounts/positions', :locals => {
          :portfolio => portfolio
        }
      end
    }
  end

  def order_books
    cache_id =  params.fetch(:cache_id, 0)
    if cache_id == '0' or cache_id == cache_key.server_state_for_account
      return render :json => {:cache_id => cache_key.server_state_for_account}
    end

    render :json => {
      :cache_id => cache_key.server_state_for_account,
      :data => cache( [ :orderbooks, cache_key.server_state_for_account ] ) do
        market = CryptoTrader::Model::Market.find(:id => params.fetch(:market_id))  
        analyzed_market = CryptoTrader::AnalyzedMarket.new(market)
        orderbook = analyzed_market.orderbook
        buy_orders = orderbook.buy_orders_with_accumulated_total(:total, :quantity ).map {|h| OpenStruct.new(h)}
        sell_orders = orderbook.sell_orders_with_accumulated_total(:total, :quantity ).map {|h| OpenStruct.new(h)}

        render_to_string :partial => 'shared/order_books', :locals => {
          :sell_orders => sell_orders,
          :buy_orders => buy_orders
        }
      end
    }
  end
end
