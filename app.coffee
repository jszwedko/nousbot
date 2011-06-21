config = require('./config').config
Bot = require './lib/bot'

bot = new Bot __dirname, config

bot.connect "bot test"