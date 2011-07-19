module.exports = class Plugin
    constructor: (@info, @subscriptions...) ->

    matchTrigger: (env) ->
        # the info object must contain a trigger attribute for this to be used
        if @info.trigger?
            pattern = RegExp "^\\#{nous.config.leader}#{@info.trigger}\\s(.*)$", "i"
            matches = env.message.match pattern
            matches[1] if matches?[1]?

    triggerOnly: (env) ->
        # returns a boolean based on whether or not a trigger was called by itself
        if @info.trigger?
            pattern = new RegExp "^\\#{nous.config.leader}#{@info.trigger}[\\s]?$", "i"
            return true if env.message.match pattern
        false

    scrape: (url, cb, options={}) ->
        # scrapes a page using node.io, callback must expect (err, $, data)
        job = new nous.nodeio.Job options, {
            input: false
            run: ->
                @getHtml url, cb
        }
        job.run()

    xml: (data, json={}) ->
        # converts an xml dump into a json object
        nous.parser.addListener "end", (results) ->
            json[k] = v for k, v of results
        nous.parser.parseString data
        json #return the json object after pushing the data to it

    say: (env, msg) ->
        nous.irc.say env.to, msg

    set: (env, key, val) ->
        nous.redis.client.set "nous-#{env.to}-#{key}", val

    get: (env, key, cb) ->
        nous.redis.client.get "nous-#{env.to}-#{key}", cb
