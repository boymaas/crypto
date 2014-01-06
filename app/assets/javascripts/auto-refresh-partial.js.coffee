$ ->
  class AutoRefreshPartial
    constructor: (@element) ->
      @partial   = @element.data('partial')
      @frequency = @element.data('frequency')
      @url       = "/partials/#{@partial}"
      @cache_id  = 0
      @start()

    params: ->
      @element.data('params')

    refresh: ->
      $.get @url, @params(), (response) =>

        if response['cache_id'] == @cache_id
          return
        @cache_id = response['cache_id']

        @element.fadeOut 500, =>
          @element.html response['data']
          @element.fadeIn 500

    set_timeout: (t,f) ->
      setTimeout(f, t)

    start: ->
      @set_timeout @frequency, =>
        @refresh()
        @start()
         

  $('.auto-refresh-partial').each (_, e) ->
    r = new AutoRefreshPartial($(e))

