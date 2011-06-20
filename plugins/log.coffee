log = module.exports

log.start = (bot) ->
  bot.addListener "message", (from, to, msg) ->
    console.log "#{from} => #{to}: #{msg}"
