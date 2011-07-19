Plugin = require "../lib/plugin"

info =
    name: "bitcoin"
    trigger: "bitcoin"
    doc: "'bitcoin' gets the current values of bitcoins from mtgox"

url = "https://mtgox.com/code/data/ticker.php"

# converts a decimal to dollar notation
d = decimalToDollars = (num) ->
    (Math.round num*100)/100

bitcoin = (env) ->
    if @triggerOnly env # if the trigger is called
        @scrape url, (err, $, data) =>
            json = JSON.parse data
            {ticker} = json if json["ticker"]?
            if ticker?
                {buy, high, low, vol} = ticker
                response = "Current: $#{d buy} - High: $#{d high} - " +
                           "Low: $#{d low} - Volume: #{vol}"
            else
                response = "Couldn't get bitcoin stats, is mt.gox down?"
            @say env, response

module.exports = {
    bitcoin: new Plugin info, bitcoin
}
