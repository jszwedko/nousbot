## urban dictionary scraper by TheEternalAbyss for nousbot
## not quite functional yet....
module.exports = (app) ->
    return {
        start: (nous) ->
            app.util.command nous, "urban", (input) ->
                url = "http://www.urbandictionary.com/define.php?term=#{(encodeURIComponent input.msg)}"
                parse url, (err, $, data) ->
                defs = []
                try
                    $('div.definition').each (def) ->
                        defs.push def.text
                catch err
                    if defs
                        response = "Found results #{defs[0]}"
                        console.log defs[0]
                    else
                        response = "did not find #{input.msg}"
                    nous.say(input.to, response)
    }