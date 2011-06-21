config = require('./config').config
Bot = require './lib/bot'

bot = new Bot __dirname, config

bot.connect "bot test"

bot.on 'connect', (id, connection) ->
    console.log "#{id} server started, jksjflakjsfjkalsd*s87d78asd8a"