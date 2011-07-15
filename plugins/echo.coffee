Plugin = require "../lib/plugin"

name = "echo"
trigger = "echo"
doc = "echos input in channel"

echo = (env) ->
    match = @matchTrigger env
    if match?
        @say match, env

module.exports =
    new Plugin {name, trigger, doc}, echo
