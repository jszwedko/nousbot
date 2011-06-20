redis = module.exports
client = module.exports

redis = require "redis"
client = redis.createClient()

client.on "error", (err) ->
  console.log "Error: #{err}"
