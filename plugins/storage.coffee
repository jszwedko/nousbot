Plugin = require "../lib/plugin"

# set plugin setup
setInfo =
    name: "set"
    trigger: "set"
    doc: "'set <key> <val>' sets a key to the given value"

set = (env) ->
    match = @matchTrigger env
    if match?
        match = match.match /(\S+)\s(.+)/
        if match?
            key = match[1]
            val = match[2]
            @set env, "storage-#{key}", val
            @say env, "Successfully set #{key} to \"#{val}\""
        else
            @say env, "Oops, set needs both a key AND a value..."


# get plugin setup
getInfo =
    name: "get"
    trigger: "get"
    doc: "'get <key>' gets a key that was previously set"

get = (env) ->
    match = @matchTrigger env
    if match?
        @get env, "storage-#{match}", (err, res) =>
            throw err if err
            if res?
                @say env, res
            else
                @say env, "No key found for #{match}"

module.exports =
    set: new Plugin setInfo, set
    get: new Plugin getInfo, get
