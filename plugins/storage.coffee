Plugin = require "../lib/plugin"

# set plugin setup
setInfo =
    name: "set"
    trigger: "set"
    doc: "'set <key> = <val>' sets a key to the given value, or you can use += to add to a key."

set = (env) ->
    match = @matchTrigger env
    if match?
        match = match.match /(.*?)\s+(\+?=)\s+(.*)/
        if match?[3]?
            key = match[1]
            safekey = key.replace /\s/g, "-"
            value = match[3]
            operator = match[2]
            if operator is "="
                @set env, "storage-#{safekey}", value
                response = "Set '#{key}' to '#{value}'"
            else if operator is "+="
                @get env, "storage-#{safekey}", (err, res) =>
                    if res?
                        value = "#{res} #{value}"
                    @set env, "storage-#{safekey}", value
                response = "Added '#{value}' to '#{key}'"
        else
            response = "Couldn't parse a key value pair."
        @respond env, response

delInfo =
    name: "del"
    trigger: "del"
    doc: "'del <key>' deletes the key from memory"

del = (env) ->
    match = @matchTrigger env
    if match?
        key = match.replace /\s/g, "-"
        @get env, "storage-#{key}", (err, res) =>
            if res?
                @del env, "storage-#{key}"
                response = "Deleted '#{match}: #{res}'"
            else
                response = "No key set for '#{match}'"
            @respond env, response

# get plugin setup
getInfo =
    name: "get"
    doc: "'?<key>' gets a key that was previously set"

get = (env) ->
    # use ?<key> and optionally ?<key> @<user>
    match = env.message.match /^\?(.*?)\s?(@.*)?$/
    match =
        if match?[1]?
            if match?[2]?
                user = match[2].replace /@/, ""
                user = user.replace /\s+/, ""
                env.from = user
            match[1]
        else
            null
    if match?
        key = match.replace /\s/g, "-"
        @get env, "storage-#{key}", (err, res) =>
            throw err if err
            if res?
                @respond env, res

module.exports =
    set: new Plugin setInfo, set
    del: new Plugin delInfo, del
    get: new Plugin getInfo, get
