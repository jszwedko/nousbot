{EventEmitter} = require 'events'

module.exports = class Bot extends EventEmitter
    constructor: (@base_path, @config) ->
        process.nous = @
        @lib_path = "#{@base_path}/lib"
        @plugin_path = "#{@base_path}/plugins"
        
        @logger = require("#{@lib_path}/logger") @
        
        @app_log = @logger "main-log"
        
        @_ = require 'underscore'
        @fs = require 'fs'
        @irc = require 'irc'
        @express = require 'express'
        
        @util = require("#{@lib_path}/util") @
        
        @plugins = {}
        @clients = {}
        @destroy = {}
        
        do =>
            @app_log.debug "=============== Loading Plugins==============="
            # loop through the plugins dir
            @fs.readdirSync("#{@plugin_path}").sort().forEach (plugin) =>
                try
                    # look for .coffee files
                    if plugin.match /^.*\.coffee$/
                        plugin = plugin.replace ".coffee", ""
                        # push matched plugins
                        if plugin not in @config.plugins.blacklist
                            path = "#{@plugin_path}/#{plugin}"
                            @plugins[plugin] = -> require(path)(process.nous)
                            @app_log.debug "Loading plugin #{plugin}"
                    else if plugin.match /^.*\.js$/
                        # favor coffee over js, but allow vanilla js plugins
                        plugin = plugin.replace ".js", ""
                        if not @plugins[plugin] and plugin not in @config.plugins.blacklist
                            path = "#{@plugin_path}/#{plugin}"
                            @plugins[plugin] = -> require(path)(process.nous)
                            @app_log.debug "Loading plugin #{plugin}"
                catch exp
                    @app_log.error exp
                    throw exp
                        
    connect: (id, options) ->
        @emit 'preconnect', id
        
        options ?= @config.network
        
        @app_log.info "Attempting to connect to #{options.server} as #{options.nick}"
        @app_log.debug "this may take a while..."
        @clients[id] = new @irc.Client options.server, options.nick, options.opts
        
        do =>
            for name, loader of @plugins # loop over plugins
                try
                    @plugins[name] = loader()
                    @plugins[name].start @clients[id] # and load each plugin
                catch err
                    @app_log.warn "failed to load plugin #{name}"
                    console.log err
        
        @emit 'connect', id, @clients[id]
        
        @clients[id].addListener 'error', @errorHandler
        @clients[id].addListener 'raw', @rawHandler if @config.debug
        @clients[id].setMaxListeners 150
        
        for channel in @config.network.opts.channels
            channel_logger = @logger channel
        
        
    errorHandler: (error) =>
        @app_log.error "ERROR: #{error.command} #{error.args.join ' '}"
        @emit 'error', error, this
        #return error
        
    rawHandler: (message) =>
        @app_log.debug "RAW: #{message.command} #{message.args.join ' '}"
