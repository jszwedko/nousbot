module.exports = (app) ->
    {command} = app.util
    
    echo = (nous) ->
        doc = "!echo <string> -- echos a given string in channel"
        command nous, "echo", doc, (input) ->
            nous.say input.to, input.msg
            
    return {
        start: echo
    }
