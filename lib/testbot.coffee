{Parser} = require "xml2js"

module.exports = class TestBot
    constructor: (@plugins...) ->
        @config = require "../config"
        @parser = new Parser()
        @nodeio = require "node.io"
        @makeGlobal()
        @makeIRC()
        @makeRedis()

    makeGlobal: ->
        global.nous ?= process.nous ?= this

    test: (env) ->
        for plugin in @plugins
            for sub in plugin.subscriptions
                sub.apply plugin, [env]

    makeIRC: ->
        @irc = say: (to, msg) => console.log "#{to} <#{@config.network.nick}> #{msg}"

    makeRedis: ->
        @memory = {}
        @redis =
            client: {
                set: (k, v) -> nous.memory[k] = v
                get: (k, cb) ->
                    if nous.memory[k]?
                        cb {}, nous.memory[k]
                    else
                        cb {}, {}
                del: (key) ->
                    if nous.memory[k]?
                        delete nous.memory[k]
            }
