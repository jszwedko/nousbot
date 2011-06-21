module.exports = (app) ->
    
    winston = require "winston"
    
    return (name) ->
        # TODO more work here... make a more meaningful logfile structure
        # ideally we would create a new logfile for each day
        # as well as unique log directories for each channel/server
        logger = new winston.Logger
            transports: [
                new winston.transports.Console()
                new winston.transports.File filename: "#{app.config.logdir}/#{name}.log"
            ]
            
        app.on 'error', (err) ->
            logger.log 'err', err.message
        
        for key, irc of app.clients
            irc.addListener "message", (from, to, msg) ->
                logger.log "info", "#{to} <#{from}>: #{msg}"
            irc.on "error", (err) ->
                logger.log "warn", "#{err.command}: #{err.args}"
        return logger