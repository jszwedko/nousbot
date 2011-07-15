Bot = require "./lib/bot"
config = require "./config"

nous =  new Bot __dirname, config
nous.connect()
