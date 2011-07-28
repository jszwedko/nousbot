# use this fancy object to perform filters based off a control list
# checks like blacklisted users, blacklisted plugins and related utilities
# still a wip

module.exports = class Seive
    constructor: (config, @plugins) ->
        @blacklist = if config.blacklist? then config.blacklist else {}
        @blacklist.chans ?= {} # channel specific blacklist
        @blacklist.users ?= {} # user specific blacklist
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
                if p in @blacklist.chans[c]
                    # if the plugin is blacklisted, put it in the blacklist
                    null
                else
                    @map[c] ?= [] # create a channel attribute if one doesn't exist
                    @map[c].push p # push the plugin through the seive and into the hash

    addToBlacklist: (type, key, plugin) ->
        if type is "chans" or type is "users"
            @blacklist[type][key] ?= []
            @blacklist[type][key].push plugin
            return true
        false

    removeFromBlacklist: (type, key, plugin) ->
        if type is "chans" or type is "users"
            if plugin in @blacklist[type][key]
                delete @blacklist[type][key][(@blacklist[type][key].indexOf plugin)]
                return true
        false

    filter: (user, chan, plugin) ->
        if user of @blacklist.users
            if plugin in @blacklist.users[user] or "*" in @blacklist.users[user]
                return false
        if chan of @blacklist.chans
            if plugin in @blacklist.chans[chan] or "*" in @blacklist.chans[chan]
                return false
        true
