class AccountsController < ApplicationController
  before_filter :authenticate_admin!, :only => [ :index, :become ]
  before_filter :authenticate_user!, :only => [ :show ]

  def index
    @users = User.all
  end

  def show
    @account = current_user.crypto_trader_account

    @last_data_collector_run = CryptoTrader::Model::DataCollectorRun.order(:id).last.id 

    market_data_provider = CryptoTrader::MarketDataProvider.new()
    account_data_provider = CryptoTrader::AccountDataProvider.new(@account)
    @portfolio = CryptoTrader::Portfolio.new(account_data_provider, market_data_provider)

    @bot_run_actions = CryptoTrader::Model::BotRunAction.
      select(:bot_run_actions.*).
      join(:bot_runs, :id => :bot_run_id).
      where(:account_id => @account.id).
      reverse_order(:id).
      limit(10)

    @desired_portfolio = CryptoTrader::Runner::DesiredPortfolio.new(@account)

    @account_trades = @account.trades_dataset.reverse_order(:timestamp).limit(10)
  end

  def become
    user = User.find(params[:id])

    # NOTE: do not track this login
    request.env["devise.skip_trackable"] = true
    sign_in(:user, user)

    redirect_to after_sign_in_path_for(user)
  end

end
