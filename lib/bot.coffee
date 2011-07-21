# nousbot, evented to the core 8)
#
# grab our deps
{EventEmitter} = require "events"
irc = require "irc"
{Parser} = require "xml2js"
Redis = require "./redis.coffee"
Sieve = require "./sieve"

# for now, nousbot will only support one irc connection (one network)
# hopefully someone can think of an elegant way to change this in the future

module.exports = class Bot extends EventEmitter
    constructor: (@dir, @config) ->
        # A bot should be passed a working dir and a configuration object
        @fs = require "fs"
        @nodeio = require "node.io"
        @parser = new Parser()
        @redis = new Redis
        @makeGlobal() # Make nous global for use across the process
        @findPlugins() # Find possible plugins

    makeGlobal: ->
        # Turn the bot into a global notifier.
        # We'll use this to control our producer/consumer callbacks
        global.nous ?= process.nous ?= this

    findPlugins: ->
        # currently, nous can only find new plugins at startup
        @pluginList = []
        @fs.readdirSync("#{@dir}/plugins").sort().forEach (plugin) =>
            if plugin.match /^.*\.coffee$/
                @pluginList.push plugin.replace ".coffee", ""

    initPlugins: ->
        # require the plugins and put them in our plugins object
        @plugins = {}
        for plugin in @pluginList
            try
                pluginModule = require "#{@dir}/plugins/#{plugin}"
                for plugin of pluginModule
                    if @plugins[plugin]
                        console.log "Looks like the plugin namespace #{plugin} is used more than once..."
                    else
                        @plugins[plugin] = pluginModule[plugin]
                        @loadPlugin @irc, @plugins[plugin]
            catch err
                console.log "There was a problem loading #{plugin}"
                @errorHandler err
                

    loadPlugin: (connection, plugin) ->
        # can't quite think of what this should do....
        connection.addListener "message", (from, to, msg) =>
            if to is @config.network.nick
                to = from
            if @sieve.filter from, to, plugin.info.name
                # ball up an environment object to ship to the plugin
                env = {}
                env.from = from
                env.to = to
                env.message = msg
                for sub in plugin.subscriptions
                    try
                        sub.apply plugin, [env]
                    catch err
                        if @config.debug?
                            throw err
                        else
                            console.log "Oops! Looks like there was a problem with #{plugin.info.name}..."
                            @errorHandler err

    errorHandler: (err) =>
        console.log "ERROR: #{err}"

    rawHandler: (message) =>
        console.log "RAW: #{message.command} #{message.args.join ' '}"

    connect: ->
        # connect to the irc server and spin up the chains
        options = @config.network
        console.log "attempting to connect to irc...."

        @irc = new irc.Client options.server, options.nick, options.opts
        @irc.setMaxListeners 512

        @irc.addListener "error", @errorHandler
        @irc.addListener "raw", @rawHandler if @config.debug

        @initPlugins()
        @sieve = new Sieve @config, (p for p of @plugins)
