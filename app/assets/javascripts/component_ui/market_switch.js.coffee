window.MarketSwitchUI = flight.component ->
  @attributes
    table: 'tbody'
    marketGroupName: '.panel-body-head thead span.name'
    marketGroupItem: '.dropdown-wrapper .dropdown-menu li a'
    marketsTable: '.table.markets'

  @switchMarketGroup = (event, item) ->
    item = $(event.target).closest('a')
    name = item.data('name')

    @select('marketGroupItem').removeClass('active')
    item.addClass('active')

    @select('marketGroupName').text "Markets"#"#{name}".toUpperCase()
    @select('marketsTable').attr("class", "table table-hover markets #{name}")

  @updateMarket = (select, ticker) ->
    trend = formatter.trend ticker.last_trend
    select.find('td.price')
     .attr('title', ticker.last)
     .html("<span class='#{trend}'>#{formatter.ticker_price ticker.last}</span>")

    p1 = parseFloat(ticker.open)
    p2 = parseFloat(ticker.last)
    trend = formatter.trend(p1 <= p2)
    select.find('td.change').html("<span class='#{trend}'>#{formatter.price_change(p1, p2)}%</span>")
  runwithdelay = (ms, func)  -> setTimeout func, ms
  run = (select, data, index) ->
    market_list = ['INR','BCH','ETH','BTC']
    currency_list = ['INR','BTC','ETH','LTC','DASH','ZEC','XRP','PPC','NMC','XMR','BCH','REP']
    if (index == market_list.length) 
      index = 0
      
      setTimeout( () -> 
                    run(select, data, index)
                , 5000)
      console.log(index);
      # return
    else 
      url = "https://min-api.cryptocompare.com/data/price?fsym="+market_list[index]+"&tsyms="
      for currency in currency_list
        url = url + currency + ","
      console.log(url)
      $.ajax(
        url: url,
        async: true,
        success: (html) ->  
          market_id = market_list[index];
          index++;
          for currency in currency_list
            value = 1/html[currency.toUpperCase()] + ''
            if(value.indexOf(".")==-1)
              value= value + '.0'
            select.find("tr#market-list-" + currency.toLowerCase() + market_id.toLowerCase()).find('td.price span').html("#{formatter.ticker_price (value)}");
          run(select ,data, index)
      )
    # console.log(data)
    # if (index == data.tickers.length) 
    #   index = 0
    #   # setTimeout(run(select, data,0), 5000)
    #   return
    # ticker = data.tickers[index]
    # $.ajax(
    #   url: "https://min-api.cryptocompare.com/data/price?fsym="+(ticker.data.base_unit.toUpperCase())+"&tsyms="+(ticker.data.quote_unit.toUpperCase()),
    #   async: true,
    #   success: (html) ->
    #     index++;
    #     value = html[ticker.data.quote_unit.toUpperCase()]+''
    #     if(value.indexOf(".")==-1)
    #       value= value + ''
    #     console.log(value)
    #     console.log(ticker.data.last)
    #     select.find("tr#market-list-#{ticker.market}").find('td.price span').html("#{formatter.ticker_price value}");
    #     if (index < data.tickers.length) 
    #       run(select,data,index)
    # )
      # 
      #       console.log("https://min-api.cryptocompare.com/data/price?fsym="+ticker.data.base_unit+"&tsyms="+ticker.data.quote_unit);
      # $.ajax(url: "https://min-api.cryptocompare.com/data/price?fsym="+(ticker.data.base_unit.toUpperCase())+"&tsyms="+(ticker.data.quote_unit.toUpperCase())).done (html) ->
      #   console.log(html);
        # select.find('td.price span').html("#{formatter.ticker_price html[ticker.data.quote_unit.toUpperCase()]}");
    # setTimeout(@run(data), 3000)

  @refresh = (event, data) ->
    table = @select('table')
    for ticker in data.tickers
      @updateMarket table.find("tr#market-list-#{ticker.market}"), ticker.data
    table.find("tr#market-list-#{gon.market.id}").addClass 'highlight'
    run(table ,data, 0)

  @after 'initialize', ->
    @on document, 'market::tickers', @refresh
    @on @select('marketGroupItem'), 'click', @switchMarketGroup

    @select('table').on 'click', 'tr', (e) ->
      unless e.target.nodeName == 'I'
        window.location.href = window.formatter.market_url($(@).data('market'))

    @.hide_accounts = $('tr.hide')
    $('.view_all_accounts').on 'click', (e) =>
      $el = $(e.currentTarget)
      if @.hide_accounts.hasClass('hide')
        $el.text($el.data('hide-text'))
        @.hide_accounts.removeClass('hide')
      else
        $el.text($el.data('show-text'))
        @.hide_accounts.addClass('hide')
