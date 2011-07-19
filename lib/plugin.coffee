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

    say: (env, msg) ->
        nous.irc.say env.to, "#{env.from}: #{msg}"

    set: (env, key, val) ->
        nous.redis.client.set "nous-#{env.to}-#{key}", val

    get: (env, key, cb) ->
        nous.redis.client.get "nous-#{env.to}-#{key}", cb
