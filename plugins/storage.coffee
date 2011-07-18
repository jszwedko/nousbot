Plugin = require "../lib/plugin"

# set plugin setup
setInfo =
    name: "set"
    trigger: "set"
    doc: "sets a key to be retrieved"

set = (env) ->
    match = @matchTrigger env
    if match?
        match = match.match /(\S+)\s(.+)/
        if match?
            key = match[1]
            val = match[2]
            @set key, val
            @say "Successfully set #{key} to \"#{val}\"", env
        else
            @say "Oops, set needs both a key AND a value...", env


# get plugin setup
getInfo =
    name: "get"
    trigger: "get"
    doc: "gets a key that was set in the channel"

get = (env) ->
    match = @matchTrigger env
    if match?
        @get match, (err, res) =>
            throw err if err
            if res?
                @say res, env
            else
                @say "No key found for #{match}", env

module.exports =
    set: new Plugin setInfo, set
    get: new Plugin getInfo, get
