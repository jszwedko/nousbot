module.exports = class Redis
    constructor: ->
        @redis = require "redis"
        @client = @redis.createClient()
        @client.on "error", (err) ->
            console.log "Redis connection error to #{client.host}: #{client.port} - #{err}"
