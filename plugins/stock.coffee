Plugin = require "../lib/plugin"

info =
    name: "stock"
    trigger: "stock"
    doc : "stock <ticker> -- searches google for the current stock value."

stock = (env) ->

    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        url = "http://www.google.com/ig/api?stock="
        urisafe = encodeURIComponent match
        url = "#{url}#{urisafe}"

        @scrape url, (err, $, data) =>
            throw err if err

            price = @xml data
            
            if price?
                results = {}
                grab = ['company', 'last', 'symbol', 'change']
                for x in grab
                    try
                        results[x] = price.finance[x]["@"].data
                    catch err
                        results[x] = ""
            
            text = 
                if results?
                    "#{results.company} (#{results.symbol}): $#{results.last} (#{results.change})"
                else
                    "Couldn't get the value of ticker symbol #{match}"
            @respond env, text

module.exports = {
    stock: new Plugin info, stock
}
