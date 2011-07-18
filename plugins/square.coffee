Plugin = require "../lib/plugin"

name = "square"
trigger = "sqr"
doc = "squares a number"

square = (env) ->
    match = @matchTrigger env
    if match?
        if isNaN parseInt match
            @say env, "Square needs to be passed an integer..."
        else
            @say env, match * match

module.exports =
    square: new Plugin {name, trigger, doc}, square
