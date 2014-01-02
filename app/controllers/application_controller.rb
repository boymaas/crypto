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

  def system_info
    SystemInfo.new
  end
end
