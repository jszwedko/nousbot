echo = module.exports

echo.start = (nous) ->
  nous.addListener "message", (from, to, msg) ->
    m = msg.match /^!echo\ (.*)$/ # there has to be a better way to do this....
    if m
      input = m[1]
      nous.say to, input
