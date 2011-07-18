module.exports = class Plugin
    constructor: (@info, @subscriptions...) ->

    matchTrigger: (env) ->
        {message} = env
        pattern = RegExp "^#{nous.config.leader}#{@info.trigger}\\s(.*)$"
        matches = message.match pattern
        matches[1] if matches?[1]?

    say: (msg, env) ->
        nous.irc.say env.to, "#{env.from}: #{msg}"

    set: (key, val) ->
        nous.redis.client.set "nous-#{key}", val

    get: (key, cb) ->
        nous.redis.client.get "nous-#{key}", cb
