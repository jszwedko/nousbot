## urban dictionary scraper by TheEternalAbyss for nousbot
## not quite functional yet....

module.exports = (app) ->
    {command, parse} = app.util

    urban = (nous) ->
        command nous, "urban", (input) ->
            urisafe = encodeURIComponent input.msg
            url = "http://www.urbandictionary.com/define.php?term=#{urisafe}"
            parse url, (err, $, data) ->
                defs = []
                try
                    $('div.definition').each (def) ->
                        defs.push def.text
                catch err
                if defs
                    response = "Found results #{defs[0]}"
                else
                    response = "did not find #{input.msg}"
                nous.say(input.to, response)

    return {
        start: urban
    }
