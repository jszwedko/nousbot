module.exports = (app) ->
    return {
        start   : (nous) ->
            app.util.command nous, "echo", (input) ->
                nous.say input.to, input.msg
    }
