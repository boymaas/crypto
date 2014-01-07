class BacktrackersController < ApplicationController
  def show
    @advisor = CryptoTrader::Bot::Advisor::MacdSignalCross.new
    @advisor_conf = @advisor.conf_options

    # we have advisor level
    #  the signals
    #
    # walk the hash
  end

  class BacktrackJob 
    @queue = :backtrack_job

    def self.perform advisor_conf, currency_list
      advisor_conf = Hash[
        advisor_conf.map {|k,v| [k.to_sym,v.to_f]}
      ]

      advisor = CryptoTrader::Bot::Advisor::MacdSignalCross.new(advisor_conf)

      runner = CryptoTrader::MarketBacktrackerRunner.new
      runner.run advisor, :on => currency_list

      # Now store results
    end
  end

  def update
    Resque.enqueue BacktrackJob, params[:advisor], CryptoTrader::Cryptsy::QualitativeMarketAnalysis.a_list
    flash[:notice] = 'Backtrack job has started'
    redirect_to :action => :show
  end
end
