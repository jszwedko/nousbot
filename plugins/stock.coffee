module.exports = (app) ->
    
    stock = (nous) ->
        doc = "!stock <ticker> -- searches google for the current stock value."
        u.command nous, "stock", doc, (input) ->
            url = "http://www.google.com/ig/api?stock=#{input.msg}"
            u.parse url, (err, $, data) ->
                {finance} = u.xml(data) #pull the finance object out of the xml data
                results = {}
                
                results[x] = finance[x]["@"]["data"] for x in ['company', 'last', 'symbol', 'change']
                
                text = if results.last and results.company
                    "#{results.company} (#{results.symbol}): $#{results.last} (#{results.change})"
                else
                    "Couldn't get the value of ticker symbol #{input.msg}"
                nous.say input.to, text

    return {
        start: stock
    }
