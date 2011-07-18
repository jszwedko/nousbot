Plugin = require "../lib/plugin"

name = "get"
trigger = "get"
doc = "gets a key that was set in the channel"

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
    new Plugin {name, trigger, doc}, get
