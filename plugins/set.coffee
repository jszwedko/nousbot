Plugin = require "../lib/plugin"

name = "set"
trigger = "set"
doc = "sets a key to be retrieved"

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
            

module.exports =
    new Plugin {name, trigger, doc}, set
