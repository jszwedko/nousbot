module.exports = (app) ->
    
    bitcoin = (nous) ->
        u.command nous, "bitcoin", doc=false, (input) ->
            url = "https://mtgox.com/code/data/ticker.php"
            u.parse url, (err, $, data) ->
                try
                    {ticker} = JSON.parse(data) # pull the ticker object out of the json
                    {buy, high, low, vol} = ticker # pull the values out of the ticker object
                    response = "Current: $#{buy} - High: $#{high} - " +
                               "Low: $#{low} - Volume: #{vol}"
                catch err
                    response = "Couldn't get bitcoin stats, is mt.gox down?."
                nous.say input.to, response

    return {
        start: bitcoin
    }
