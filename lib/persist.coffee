persist = module.exports

persist.redis = require "redis"
persist.client = redis.createClient()

client = persist.client
client.on "error", (err) ->
  console.log "Error: #{err}"
