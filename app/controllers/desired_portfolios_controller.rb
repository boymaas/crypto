class DesiredPortfoliosController < ApplicationController
  def update
    items_to_update = params.keys.select {|p| p.match(/^item_\d/) }.map {|p| [ p.gsub(/^item_/,'').to_i, params[p].to_f ] }
    percentage_in_trending_markets = params['percentage_in_trending_markets'].to_f

    @account = current_user.crypto_trader_account
    @desired_portfolio = CryptoTrader::Runner::DesiredPortfolio.new(@account)
    begin
      # NOTE: transaction will be rolled back on error and nothing will be saved
      CryptoTrader::DB.transaction do
        @desired_portfolio.update_items items_to_update, percentage_in_trending_markets
      end
    rescue CryptoTrader::Runner::DesiredPortfolio::PercentageOverflow
      return render :json => { :status => 'error', :error => 'percentage_overflow' }
    end

    render :json => { :status => 'success' }
  end
end
