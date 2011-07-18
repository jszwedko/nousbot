module.exports = class Plugin
    constructor: (@info, @subscriptions...) ->

    matchTrigger: (env) ->
        {message} = env
        pattern = RegExp "^#{nous.config.leader}#{@info.trigger}\\s(.*)$"
        matches = message.match pattern
        matches[1] if matches?[1]?

    say: (env, msg) ->
        nous.irc.say env.to, "#{env.from}: #{msg}"

    set: (env, key, val) ->
        nous.redis.client.set "nous-#{env.to}-#{key}", val

    get: (env, key, cb) ->
        nous.redis.client.get "nous-#{env.to}-#{key}", cb
