class AccountsController < ApplicationController
  def index
    @accounts = CryptoTrader::Model::Account.all
  end

  def show
    @account = CryptoTrader::Model::Account.find(:id => params.fetch(:id))

    market_data_provider = CryptoTrader::MarketDataProvider.new()
    account_data_provider = CryptoTrader::AccountDataProvider.new(@account)
    @portfolio = CryptoTrader::Portfolio.new(account_data_provider, market_data_provider)

    @account_trades = @account.trades_dataset.reverse_order(:timestamp).limit(10)
  end
end
