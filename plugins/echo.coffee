echo = module.exports
{command} = require "./util"

echo.start = (nous) ->
  command nous, "echo", (input) ->
    nous.say input.to, input.msg
