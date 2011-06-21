EventEmitter = require('events').EventEmitter

module.exports = class Bot extends EventEmitter
    constructor: (@base_path, @config) ->
        @logger = require 'winston'
        
        @_ = require 'underscore'
        @fs = require 'fs'
        @irc = require 'irc'        
        @express = require 'express'
        
        @plugins = {}
        @clients = {}
        
        do =>
            @logger.debug "=============== Loading Plugins==============="
            # loop through the plugins dir
            @fs.readdirSync("#{@base_path}/plugins").forEach (plugin) =>
                # look for .coffee files
                if plugin.match /^.*\.coffee$/
                    plugin = plugin.replace ".coffee", ""
                    @logger.debug "Loading plugin #{plugin}"
                    # push matched plugins
                    @plugins[plugin] = =>
                        require "#{@base_path}/plugins/#{plugin}"
                        
    connect: (id, options) ->
        options ?= @config.network
        
        @logger.info "Attempting to connect to #{options.server} as #{options.nick}"
        @logger.debug "this may take a while..."
        @clients[id] = new @irc.Client options.server, options.nick, options.opts
        
        @clients[id].addListener 'error', @errorHandler
        
        @clients[id].addListener 'raw', @rawHandler
        
    errorHandler: (error) =>
        @logger.error "ERROR: #{error.command} #{error.args.join ' '}"
        @emit 'error', error, this
        return error
        
    rawHandler: (message) =>
        @logger.debug "RAW: #{message.command} #{message.args.join ' '}"
        
                
        

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