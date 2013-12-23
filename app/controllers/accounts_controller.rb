class AccountsController < ApplicationController
  def index
    @accounts = CryptoTrader::Model::Account.all
  end
end
