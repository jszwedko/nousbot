module.exports = (app) ->
    {command} = app.util

    echo = (nous) ->
        command nous, "echo", (input) ->
            nous.say input.to, input.msg

    return {
        start: echo
    }
