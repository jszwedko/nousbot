EventEmitter = require('events').EventEmitter

module.exports = class Bot extends EventEmitter
    constructor: (@base_path, @config) ->
        @lib_path = "#{@base_path}/lib"
        @plugin_path = "#{@base_path}/plugins"
        
        @logger = require("#{@lib_path}/logger") @
        
        @app_log = @logger "main-log"
        
        @_ = require 'underscore'
        @fs = require 'fs'
        @irc = require 'irc'        
        @express = require 'express'
        
        @util       = require "#{@lib_path}/util"
        
        @command = require("#{@lib_path}/util").command
        @parse   = require("#{@lib_path}/util").parse
        
        @plugins = {}
        @clients = {}
        
        do =>
            @app_log.debug "=============== Loading Plugins==============="
            # loop through the plugins dir
            @fs.readdirSync("#{@plugin_path}").sort().forEach (plugin) =>
                @app_log.debug "Loading plugin #{plugin}"
                try
                    # look for .coffee files
                    if plugin.match /^.*\.coffee$/
                        plugin = plugin.replace ".coffee", ""
                        # push matched plugins
                        @plugins[plugin] = require("#{@plugin_path}/#{plugin}")(@)
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
                    name = loader() # and load each plugin
                    name.start(@clients[id])
                catch err
                    @app_log.warn "failed to load plugin #{name}"
        
        @emit 'connect', id, @clients[id]
        
        @clients[id].addListener 'error', @errorHandler
        @clients[id].addListener 'raw', @rawHandler if @config.debug
        
    errorHandler: (error) =>
        @app_log.error "ERROR: #{error.command} #{error.args.join ' '}"
        @emit 'error', error, this
        #return error
        
    rawHandler: (message) =>
        @app_log.debug "RAW: #{message.command} #{message.args.join ' '}"
        
                
        

###
# load the project configuration
{config} = require "./config" # pull config out of config file
{network} = config # pull the values out of config 
{server, nick, opts} = network

# load project dependencies
irc = require "irc"
fs = require "fs"

# define the connection method
connect = ->
  console.log "Attempting to connect to #{server} as #{nick}"
  console.log "this may take a while..."
  new irc.Client server, nick, opts

plugins = {} # create an empty object for pushing to


nous = connect() # create the irc connection
for name, loader of plugins # loop over plugins
  try
    name = loader() # and load each plugin
    name.start(nous)
  catch err
    console.log "failed to load plugin #{name}"
###