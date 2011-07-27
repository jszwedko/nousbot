{Parser} = require "xml2js"
storage = require "./storage"

module.exports = class TestBot
    constructor: (@plugins...) ->
        @config = require "../config"
        @parser = new Parser()
        @nodeio = require "node.io"
        @makeGlobal()
        @makeIRC()
        @buildStorage()

    makeGlobal: ->
        global.nous ?= process.nous ?= this

    test: (envs...) ->
        for env in envs
            do (env) =>
                for plugin in @plugins
                    for sub in plugin.subscriptions
                        do (sub) -> sub.apply plugin, [env]

    makeIRC: ->
        @irc = say: (to, msg) => console.log "#{to} <#{@config.network.nick}> #{msg}"

    buildStorage: ->
        if nous.config.redis?
            @store = new storage.Redis nous.config.redis
        else if nous.config.storagepath?
            @store = new storage.JStore nous.config.storagepath
        else
            @store = new storage.Memstore

