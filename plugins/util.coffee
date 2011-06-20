util = module.exports

leader = "!"

util.command = (nous, pattern, callback) ->
  regex = leader + pattern + "\ (.*)"
  nous.addListener "message", (from, to, msg) ->
    match = msg.match RegExp(regex)
    if match
      input =
        msg: match[1]
        from: from
        to: to
      callback input

util.start = (nous) ->
  console.log "loaded plugin utility..."
