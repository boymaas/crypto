$ ->
  class AutoRefreshPartial
    constructor: (@element) ->
      @partial   = @element.data('partial')
      @frequency = @element.data('frequency')
      @url       = "/partials/#{@partial}"
      @cache_id  = 0
      @params    = @extract_params()
      @fetch_cache_key_and_start()

    extract_params: ->
      params = {}
      # NOTE: for .. in enum and for .. of object
      for own n,v of @element.data()
        if /^param_/.test(n)
          params[n.substring(6)] = v
      params

    refresh_and_start: (no_update=false) ->
      params = $.extend(@params, {cache_id: @cache_id})
      $.getJSON(@url, params).done (response) =>

        if response['cache_id'] == @cache_id
          return
        @cache_id = response['cache_id']

        # first request we are only interested
        # in the cache key
        if no_update
          return

        @element.fadeOut 500, =>
          @element.html response['data']
          @element.fadeIn 500
      .always =>
        @start()

    set_timeout: (t,f) ->
      setTimeout(f, t)

    fetch_cache_key_and_start: ->
      @refresh_and_start(true)

    start: ->
      @set_timeout @frequency, =>
        @refresh_and_start(false)
         

  $('.auto-refresh-partial').each (_, e) ->
    r = new AutoRefreshPartial($(e))

