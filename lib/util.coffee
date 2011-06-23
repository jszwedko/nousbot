module.exports = (app) ->

    nodeio = require "node.io"
    {Parser} = require "xml2js"
    options = {}

    command = (nous, pattern, doc, callback) ->
        regex = "^#{app.config.leader + pattern}\ (.*)"

        onCommand = (from, to, msg) ->
            match = msg.match RegExp(regex)
            if match
                input =
                    msg: match[1]
                    from: from
                    to: to
                callback input
            else if msg.match RegExp "#{app.config.leader + pattern}"
                nous.say to, doc

        nous.addListener "message", onCommand

        app.destroy[pattern] = (nous) ->
            nous.removeListener "message", onCommand

    parse = (url, callback) ->
        job = new nodeio.Job options, {
            input: false
            run: ->
                @getHtml url, callback
        }
        job.run()

    xml = (xml) ->
        json = {}
        parser = new Parser()
        parser.addListener "end", (results) ->
            console.log k for k in results
            json[k] = v for k, v of results
        parser.parseString xml
        return json

    start = (nous) ->
        console.log "loaded plugin utility..."

    return {
        start: start
        xml: xml
        parse: parse
        command: command
    }
