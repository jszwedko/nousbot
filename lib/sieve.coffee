# use this fancy object to perform filters based off a control list
# checks like blacklisted users, blacklisted plugins and related utilities
# still a wip

module.exports = class Seive
    constructor: (config, @plugins) ->
        @blacklist = if config.blacklist? then config.blacklist else {}
        @chans =
            if config.network.opts.channels?
                config.network.opts.channels
            else
                {}
        @map = {}
        @buildPluginMap()


    # buildPluginMap builds the initial plugin hashmap needed for plugin ACL
    # as well as loading/unloading plugins
    buildPluginMap: ->
        for c in @chans # then loop through the channels
            for p in @plugins # in every channel, check every plugin possible
                if c in @blacklist.plugins[p] or "*" in @blacklist.plugins[p]
                    # if the plugin is blacklisted, do nothing
                    null
                else
                    @map[c] ?= [] # create a channel attribute if one doesn't exist
                    @map[c].push p # push the plugin through the seive and into the hash

    filter: (dontCareYet...) ->
        true
