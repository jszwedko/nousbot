Plugin = require "../lib/plugin"

name = "square"
trigger = "sqr"
doc = "squares a number"

square = (env) ->
    match = @matchTrigger env
    if match?
        if isNaN parseInt match
            @say "Square needs to be passed an integer...", env
        else
            @say match * match, env

module.exports =
    new Plugin {name, trigger, doc}, square
