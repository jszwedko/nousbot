module.exports = class Plugin
    constructor: (@info, @subscriptions...) ->
        @decode = require "./html_entities"
        @info.keyprefix ?= @info.name

    matchTrigger: (env) ->
        # the info object must contain a trigger attribute for this to be used
        if @info.trigger?
            # fancy ass regex, captures matched input and possibly @user
            pattern = new RegExp "^\\#{nous.config.leader}#{@info.trigger}\\s(.*?)\\s?(@.*)?$", "i"
            matches = env.message.match pattern
            if matches?[1]?
                if matches?[2]?
                    user = matches[2].replace /@/, ""
                    user = user.replace /\s+/, ""
                    # if we find an @user match, set the environment user to this user
                    env.from = user
                return matches[1]

    # Takes an environment and checks if the message was only this plugins trigger
    triggerOnly: (env) ->
        # returns a boolean
        if @info.trigger?
            pattern = new RegExp "^\\#{nous.config.leader}#{@info.trigger}\\s*$", "i"
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


    isEmptyObject :  (obj) ->
        if typeof obj isnt 'object'
            return false

        for prop of obj
            if obj.hasOwnProperty prop then return false
        true

    cleanHTML: (html) ->
        # takes a string of messy xml or html and cleans it
        # strips xml tags, decodes html entities, removes extra whitespace
        html = @decode (unescape html), "ENT_QUOTES"
        html = html.replace /(<([^>]+)>)/ig, "" # replace all xml tags with empty strings
        html = html.replace /\s+/g, " " # replace multiple spaces with a single space

    say: (env, msg) ->
        # say a message to the given environment
        nous.irc.say env.to, msg

    respond: (env, msg) ->
        # respond to whoever invoked the command
        nous.irc.say env.to, "#{env.from}: #{msg}"

    set: (env, key, val) ->
        # set a key to a value, prefixed with "nous"
        nous.store.client.set "nous-#{env.to}-#{@info.keyprefix}-#{key}", val
        if nous.store.jstore?
            nous.store.save()

    get: (env, key, cb) ->
        nous.store.client.get "nous-#{env.to}-#{@info.keyprefix}-#{key}", cb

    del: (env, key) ->
        nous.store.client.del "nous-#{env.to}-#{key}"
