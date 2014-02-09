class StockChart
  constructor: (@id) ->

  load: (market_label) ->
    $.getJSON "/stats/#{market_label}/graph-data-json", (data) =>
      # split the data set into ohlc and volume
      timestamps = data['timestamps']
      volumes = data['volumes']
      prices = data['prices']
      signals = data['signals']
      buy_threshold = data['buy-threshold']
      sell_threshold = data['sell-threshold']

      ohlc = _.zip timestamps, prices
      volume = _.zip timestamps, volumes

      for k,v of signals
        signals[k] = _.zip timestamps, v

      # for e in data
      #   ohlc.push [e[0], e[1]]
      #   # the date
      #   volume.push [e[0], e[2]]

      #   for [ n, v ] in e[3]
      #     signals[n] ||= []
      #     signals[n].push [e[0], v]

      signal_series = for n, sd of signals
        type: "line"
        name: n
        data: sd
        lineWidth: 1
        yAxis: 1

      $(@id).highcharts "StockChart",
        chart:
          events:
            load: (e) =>
              if $.cookie('market_chart_extremes_min')?
                min = parseInt($.cookie('market_chart_extremes_min'))
                max = parseInt($.cookie('market_chart_extremes_max'))
                e.target.xAxis[0].setExtremes(new Date(min), new Date(max))

        xAxis:
          events:
            setExtremes: (e) =>
              if e.trigger?
                $.cookie 'market_chart_extremes_min', e.min
                $.cookie 'market_chart_extremes_max', e.max

        rangeSelector:
          selected: 10
          buttons: [
            type: 'hour',
            count: 4,
            text: '4h'
          ,
            type: 'hour',
            count: 8,
            text: '8h'
          ,
            type: 'hour',
            count: 12,
            text: '12h'
          ,
            type: 'day',
            count: 1,
            text: '1d'
          ,
            type: 'day',
            count: 2,
            text: '2d'
          ,
            type: 'day',
            count: 3,
            text: '3d'
          ,
            type: 'day',
            count: 5,
            text: '5d'
          ,
            type: 'month',
            count: 1,
            text: '1m'
          ,
            type: 'month',
            count: 6,
            text: '6m'
          ,
            type: 'year',
            count: 1,
            text: '1y'
          ,
            type: 'all',
            text: 'All'
          ]

        title:
          text: market_label

        subtitle:
          text: "Average Trading Price / Volume"


        yAxis: [
          title:
            text: "AVG TP"
          height: 200
          lineWidth: 2
        ,
          title:
            text: "SIG"
          top: 290
          height: 200
          offset: 0
          max: 1
          min: -1
          lineWidth: 2
          plotLines: [
            id: 'limit-max',
            color: '#aaf',
            dashStyle: 'LongDash',
            width: 1,
            value: buy_threshold,
            zIndex: 0
          ,
            id: 'limit-min',
            color: '#aaf',
            dashStyle: 'LongDash',
            width: 1,
            value: sell_threshold,
            zIndex: 0
          ]
        ,
          title:
            text: "Volume BTC"
          top: 500
          height: 100
          offset: 0
          lineWidth: 2
        ]

        tooltip:
          valueDecimals: 8

        series: [
          type: "line"
          name: market_label
          data: ohlc
          yAxis: 0
          lineWidth: 2
        ,
        ].concat(signal_series).concat [
          type: "column"
          name: "Volume BTC"
          data: volume
          yAxis: 2
        ]

root = exports ? this
root.StockChart = StockChart
