module.exports = (app) ->

    nodeio = require "node.io"
    {Parser} = require "xml2js"
    options = {}

    command = (nous, pattern, doc, callback) ->
        regex = "^#{app.config.leader + pattern}\ (.*)"

        onCommand = (from, to, msg) ->
            input =
                from: from
                to: to
            match = msg.match RegExp(regex)
            if match
                input["msg"] = match[1]
                callback input
            else if msg.match RegExp "^#{app.config.leader + pattern}$"
                if doc
                    nous.say to, "#{from}: #{doc}"
                else
                    callback input

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

    striptags = (string) ->
        string.replace /(<([^>]+)>)/ig, "" # replace all xml tags with empty strings
        string.replace /\s+/, " " # replace multiple spaces with a single space

    start = (nous) ->
        console.log "loaded plugin utility..."

    return {
        start: start
        xml: xml
        parse: parse
        command: command
        striptags: striptags
    }
