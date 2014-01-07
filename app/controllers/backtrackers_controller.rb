class BacktrackersController < ApplicationController
  def show
    @advisor = CryptoTrader::Bot::Advisor::MacdSignalCross.new
    @advisor_conf = @advisor.conf_options

    # we have advisor level
    #  the signals
    #
    # walk the hash
  end

  def update
    @advisor_conf = Hash[
    params[:advisor].map {|k,v| [k.to_sym,v.to_f]}
    ]

    
    @advisor = CryptoTrader::Bot::Advisor::MacdSignalCross.new(@advisor_conf)

    @markets = CryptoTrader::Model::Market.
      where(:primary_currency_code => CryptoTrader::Cryptsy::QualitativeMarketAnalysis.a_list).
      where(:secondary_currency_code => 'BTC')

    @markets = @markets.take(1)
    @results = @markets.map {|m| CryptoTrader::MarketBacktracker.new(m).backtrack(@advisor) }
    @results = @results.sort_by {|r| r.resulting_budget }.reverse
    
  end
end
