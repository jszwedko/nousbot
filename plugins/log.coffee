log = module.exports
winston = require "winston"
{config} = require "../config"

createLogger = ->
  # TODO more work here... make a more meaningful logfile structure
  # ideally we would create a new logfile for each day
  # as well as unique log directories for each channel/server
  new winston.Logger
    transports: [
      new winston.transports.Console()
      new winston.transports.File filename: "#{config.logdir}/nous.log"
    ]

logger = createLogger()
log.logger = nouslog

log.start = (bot) ->
  bot.addListener "message", (from, to, msg) ->
    nouslog.log "info", "#{to} <#{from}>: #{msg}"
