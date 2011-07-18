Plugin = require "../lib/plugin"

info =
  name: "square"
  trigger: "sqr"
  doc: "'sqr <number>' returns the squares of a number"

square = (env) ->
    match = @matchTrigger env
    if match?
        if isNaN parseInt match
            @say env, "Square needs to be passed an integer..."
        else
            @say env, match * match

module.exports =
    square: new Plugin info, square
