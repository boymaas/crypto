class AccountsController < ApplicationController
  def index
    @accounts = CryptoTrader::Model::Account.all
  end

  def show
    @account = CryptoTrader::Model::Account.find(:id => params.fetch(:id))
    @account_trades = @account.trades_dataset.reverse_order(:timestamp).limit(10)
  end
end
