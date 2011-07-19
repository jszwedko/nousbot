module.exports = class Plugin
    constructor: (@info, @subscriptions...) ->

    matchTrigger: (env) ->
        # the info object must contain a trigger attribute for this to be used
        if @info.trigger?
            pattern = RegExp "^\\#{nous.config.leader}#{@info.trigger}\\s(.*)$", "i"
            matches = env.message.match pattern
            matches[1] if matches?[1]?

    # Takes an environment and checks if the message was only this plugins trigger
    triggerOnly: (env) ->
        # returns a boolean
        if @info.trigger?
            pattern = new RegExp "^\\#{nous.config.leader}#{@info.trigger}[\\s]?$", "i"
            return true if env.message.match pattern
        false

    scrape: (url, cb, options={}) ->
        # scrapes a page using node.io, callback must expect (err, $, data)
        # where err is an error, $ is a soupselect object
        # and data is the raw string of the response body
        job = new nous.nodeio.Job options, {
            input: false
            run: ->
                @getHtml url, cb
        }
        job.run()

    
    xml: (data, json={}) ->
        # converts an xml dump into a json object
        jsonPush = (results) ->
            for k, v of results
                do (k, v) ->
                    json[k] = v
            nous.parser.removeListener "end", jsonPush
        nous.parser.addListener "end", jsonPush
        nous.parser.parseString data
        json #return the json object after pushing the data to it

    say: (env, msg) ->
        nous.irc.say env.to, msg

    respond: (env, msg) ->
        nous.irc.say env.to, "#{env.from}: #{msg}"

    set: (env, key, val) ->
        nous.redis.client.set "nous-#{env.to}-#{key}", val

    get: (env, key, cb) ->
        nous.redis.client.get "nous-#{env.to}-#{key}", cb
