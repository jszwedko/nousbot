module.exports = class Plugin
    constructor: (@info, @subscriptions...) ->
        @decode = require "./html_entities"
        @info.keyprefix ?= @info.name

    matchTrigger: (env, trigger) ->
        trigger ?= @info.trigger

        # the info object must contain a trigger attribute for this to be used
        if trigger?
            # fancy ass regex, captures matched input and possibly @user
            pattern = new RegExp "^\\#{nous.config.leader}#{trigger}\\s(.*?)\\s?(@.*)?$", "i"
            matches = env.message.match pattern
            if matches?[1]?
                if matches?[2]?
                    user = matches[2].replace /@/, ""
                    user = user.replace /\s+/, ""
                    # if we find an @user match, set the environment user to this user
                    env.from = user
                return matches[1]

    # Takes an environment and checks if the message was only this plugins trigger
    triggerOnly: (env, trigger) ->
        trigger ?= @info.trigger

        # returns a boolean
        if trigger?
            pattern = new RegExp "^\\#{nous.config.leader}#{trigger}\\s*$", "i"
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

    set: (env, keys, vals) ->
        unless keys instanceof Array
            keys = [keys]
        unless vals instanceof Array
            vals = [vals]

        if keys.length isnt vals.length
            throw 'Key and values aren\'t the same length'

        prefixedKeys = []
        prefixedKeys.push "nous-#{env.to}-#{@info.keyprefix}-#{key}" for key in keys

        # set keys to values, prefixed with "nous"
        nous.store.set prefixedKeys, vals
        if nous.store.jstore?
            nous.store.save()

    get: (env, keys..., cb) ->
        if keys.length is 1 and keys[0] instanceof Array #if array is passed
            keys = keys[0]

        prefixedKeys = []
        prefixedKeys.push "nous-#{env.to}-#{@info.keyprefix}-#{key}" for key in keys
        nous.store.get prefixedKeys, cb

    del: (env, keys...) ->
        if keys.length is 1 and keys[0] instanceof Array #if array is passed
            keys = keys[0]

        prefixedKeys = []
        prefixedKeys.push "nous-#{env.to}-#{@info.keyprefix}-#{key}" for key in keys
        nous.store.del prefixedKeys

    startTransaction: (cb) ->
        nous.store.startTransaction cb

    rollback: ->
        nouse.store.rollback()

    commit: (cb) ->
        nous.store.commit cb
