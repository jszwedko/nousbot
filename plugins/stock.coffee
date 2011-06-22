module.exports = (app) ->
    {command, parse} = app.util
    
    stock = (nous) ->
        command nous, "stock", (input) ->
            url = "http://www.google.com/ig/api?stock=#{input.msg}"
            parse url, (err, $, data) ->
                results = {}
                results[x] = ($ x).attribs.data for x in ['company', 'last', 'symbol', 'change']
                
                text = if results.last and results.company
                    "#{results.company} (#{results.symbol}): $#{results.last} (#{results.change})" 
                else
                    "Couldn't get the value of ticker symbol #{input.msg}"
                nous.say input.to, text

    return {
        start: stock
    }
