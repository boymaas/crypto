class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for( resource )
    case resource
    when User
      account_path
    when Admin
      accounts_index_path
    end
  end

  # TODO: place in own class
  class SystemInfo
    def last_data_collector_run
      CryptoTrader::Model::DataCollectorRun.reverse_order(:id).first
    end

    def last_bot_run(account=nil)
      if account
        account.bot_runs_dataset.reverse_order(:id).first
      else
        CryptoTrader::Model::BotRun.reverse_order(:id).first
      end
    end
  end

  class DataProvider
    def initialize(controller)
      @controller = controller
    end
    def bot_run_actions opts={}
      account = opts.fetch :account, current_crypto_trader_account
      market = opts.fetch :market, nil
      CryptoTrader::DB[<<-sql, account.id].map {|r| OpenStruct.new(r) }
        select bra.*, bra.market_id, m.label as market_label 
          from bot_run_actions bra
          inner join bot_runs br
          on bra.bot_run_id = br.id
          inner join markets m
          on bra.market_id = m.id
          where account_id = ?
          #{market && "and m.id = #{market.id}"}
          order by bra.timestamp desc
          limit 40
      sql
    end
    def account_trades account
      CryptoTrader::DB[<<-sql, account.id].map {|r| OpenStruct.new(r)}
        select at.*, m.id as market_id, m.label as market_label 
          from account_trades at
          inner join markets m 
          on at.market_id = m.id
          where at.account_id = ?
          order by at.timestamp desc
          limit 40
      sql
    end
    def account_trades_on_market account, market
      CryptoTrader::DB[<<-sql, account.id, market.id].map {|r| OpenStruct.new(r)}
        select at.*, m.id as market_id, m.label as market_label 
          from account_trades at
          inner join markets m 
          on at.market_id = m.id
          where at.account_id = ?
            and m.id = ?
          order by at.timestamp desc
          limit 40
      sql
    end
    def current_crypto_trader_account
      @current_account ||= current_user.crypto_trader_account
    end
    def current_user
      @controller.current_user
    end
  end

  def data_provider
    @_data_provider ||= DataProvider.new(self)
  end

  def system_info
    @_system_info ||= SystemInfo.new
  end

  def cache_key_logged_in_users
    [ (current_user && current_user.id), ( current_admin && current_admin.id ) ]
  end
end
