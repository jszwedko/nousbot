stock = module.exports
{command, parse} = require "./util"

stock.start = (nous) ->
  command nous, "stock", (input) ->
    url = "http://www.google.com/ig/api?stock=#{input.msg}"
    parse url, (err, $, data) ->
      latest = ($ "last").attribs.data
      ticker = ($ "symbol").attribs.data
      if latest
        nous.say input.to, "#{ticker}: $#{latest}"
      else
        nous.say input.to, "Couldn't get the value of ticker symbol #{input.msg}"
