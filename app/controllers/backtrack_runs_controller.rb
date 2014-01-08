class BacktrackRunsController < ApplicationController
  def index
    @backtrack_runs = CryptoTrader::Model::BacktrackRun.all
  end
end
