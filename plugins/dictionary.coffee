Plugin = require "../lib/plugin"

ninjaInfo =
    name: 'dictionary'
    trigger: 'define'
    doc: 'define <word> -- fetches definition of <word>'

ninjaDictionary = (env) ->
    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        url = 'http://ninjawords.com/'
        urisafe = encodeURIComponent match
        url = "#{url}#{urisafe}"

        @scrape url, (err, $, data) =>
            throw err if err

            try
                defs = []
                suggested = $('dt.title-word a').text
                response = ""

                if suggested is match
                    $('div.definition').each (def) ->
                        def = ((def.striptags).match /deg;(.*)/)
                        if def and def.length > 1
                            def = def[1]
                            defs.push def
                        if defs
                            defstring = ""
                            defstring += "#{i+1} #{def} " for def, i in defs
                            response = "#{match}: #{defstring}"
                else
                    response = "Perhaps you meant #{suggested}"
            catch err
                response = "#{match} is not in the dictionary."

            try
                response = $('table#entries tr td.word')?.first()?.text?.trim() +
                            ": " + $('table#entries tr td div.definition')?.first()?.text?.trim()

                if response?.length + url.length > 400
                    response = response[..400-url.length] + "..."

            if !response or response is ": "
                response = "No definitions found for #{match}"
            else
                response += " [#{url}]"

            @respond env, response

urbanInfo =
    name: 'urban'
    trigger: 'urban'
    doc: 'urban <phrase> -- looks up <phrase> on urbandictionary.com'

urbanDictionary = (env) ->
    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        url = 'http://www.urbandictionary.com/define.php?term='
        urisafe = encodeURIComponent match
        url = "#{url}#{urisafe}"

        @scrape url, (err, $, data) =>
            throw err if err

            try
                response = $('table#entries tr td.word')?.first()?.text?.trim() +
                            ": " + $('table#entries tr td div.definition')?.first()?.text?.trim()

                if response?.length + url.length > 400
                    response = response[..400-url.length] + "..."

            if !response or response is ": "
                response = "No definitions found for #{match}"
            else
                response += " [#{url}]"

            @respond env, response

etymologyInfo =
    name: 'etymology'
    trigger: 'etymology'
    doc: 'etymology <word> -- Retrieves the etymology of chosen word'
            
etymologyDictionary = (env) ->
    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        url = 'http://www.etymonline.com/index.php?term='
        urisafe = encodeURIComponent match
        url = "#{url}#{urisafe}"

        @scrape url, (err, $, data) =>
            throw err if err

            try
                response = $('div#dictionary dl').fulltext?.trim()

                if response?.length + url.length > 400
                    response = response[..400-url.length] + "..."

            if !response
                response = "No etymology found for #{match}"
            else
                response += " [#{url}]"

            @respond env, response

module.exports = {
    urbanDictionary: new Plugin urbanInfo, urbanDictionary
    etymologyDictionary: new Plugin etymologyInfo, etymologyDictionary
    ninjaDictionary: new Plugin ninjaInfo, ninjaDictionary
}
