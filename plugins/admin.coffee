admin = module.exports
{command} = require "./util"
{config} = require "../config"
{admins} = config # can I pull this out as a one liner?

admin.start = (nous) ->
  command nous, "kick", (input) ->
    if input.from in admins
      nous.say input.to, "screw you #{input.msg}"
      nous.send "kick", input.to, input.msg
  command nous, "ban", (input) ->
    if input.from in admins
      nous.say input.to, "gtfo #{input.msg}"
      nous.send "MODE", input.to, "+b", input.msg
      nous.send "kick", input.to, input.msg
  command nous, "unban", (input) ->
    if input.from in admins
      nous.say input.to, "mehh...."
      nous.send "MODE", input.to, "-b", input.msg

