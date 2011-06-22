{config} = require './config'
Bot = require './lib/bot'

bot = new Bot __dirname, config

bot.on 'connect', (id, connection) ->
    console.log "#{id} server started"

bot.connect "nous bot"
