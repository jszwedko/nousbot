util = module.exports

nodeio = require "node.io"
{Parser} = require "xml2js"
options = {}

leader = "!"

util.command = (nous, pattern, callback) ->
    regex = "^#{leader + pattern}\ (.*)"
    nous.addListener "message", (from, to, msg) ->
        match = msg.match RegExp(regex)
        if match
            input =
                msg: match[1]
                from: from
                to: to
            callback input

util.parse = (url, callback) ->
    job = new nodeio.Job options, {
        input: false
        run: ->
            @getHtml url, callback
    }
    job.run()

util.xml = (xml) ->
    json = {}
    parser = new Parser()
    parser.addListener "end", (results) ->
        console.log k for k in results
        json[k] = v for k, v of results
    parser.parseString xml
    return json

util.start = (nous) ->
    console.log "loaded plugin utility..."
