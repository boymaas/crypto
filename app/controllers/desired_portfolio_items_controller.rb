class DesiredPortfolioItemsController < SecuredController
  def create
    account = current_user.crypto_trader_account
    market = CryptoTrader::Model::Market.find :id => params.fetch(:market_id)

    desired_portfolio = CryptoTrader::Runner::DesiredPortfolio.new(account)
    desired_portfolio.add market, 0.0

    flash[:notice] = "#{market.label} added to desired portfolio"

    redirect_to account_path
  end

  def destroy
    account = current_user.crypto_trader_account
    item_dataset = account.desired_portfolio.items_dataset.where(:id => params[:id])
    item = item_dataset.first
    item_dataset.delete
    redirect_to :back, :notice => "#{item.market.label} removed from Desired position"
  end
end
