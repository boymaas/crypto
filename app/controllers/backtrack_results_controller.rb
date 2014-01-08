class BacktrackResultsController < ApplicationController
  def index
    @backtrack_run = CryptoTrader::Model::BacktrackRun.find(:id => params[:backtrack_run_id])
    @backtrack_results = @backtrack_run.results
  end
end
