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
      account_id = opts.fetch :account_id, current_crypto_trader_account.id
      market_id = opts.fetch :market_id, nil
      bot_run_id = opts.fetch :bot_run_id, nil
      CryptoTrader::DB[<<-sql, account_id].map {|r| OpenStruct.new(r) }
        select bra.*, bra.market_id, m.label as market_label 
          from bot_run_actions bra
          inner join bot_runs br
          on bra.bot_run_id = br.id
          inner join markets m
          on bra.market_id = m.id
          where account_id = ?
          #{market_id && "and m.id = #{market_id}"}
          #{bot_run_id && "and br.id = #{bot_run_id}"}
          order by bra.timestamp desc
          limit 40
      sql
    end
    def account_trades opts={}
      account_id = opts.fetch :account_id, current_crypto_trader_account.id
      market_id = opts.fetch :market_id, nil
      CryptoTrader::DB[<<-sql, account_id].map {|r| OpenStruct.new(r)}
        select at.*, m.id as market_id, m.label as market_label 
          from account_trades at
          inner join markets m 
          on at.market_id = m.id
          where at.account_id = ?
          #{market_id && "and m.id = #{market_id}"}
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

  class CacheKeys
    def initialize controller
      @controller = controller
      @system_info = controller.system_info
    end

    def logged_in_users
      md5(_logged_in_users_key)
    end

    def server_state_for_account
      md5([ _logged_in_users_key, @system_info.last_bot_run.id, @system_info.last_data_collector_run.id] * "::")
    end

    private

    def _logged_in_users_key
      [ (@controller.current_user && @controller.current_user.id),
        ( @controller.current_admin && @controller.current_admin.id ) ] * "::"
    end

    def md5 *a
      Digest::MD5.hexdigest(*a)
    end
  end

  def cache_key
    CacheKeys.new(self)
  end
end
