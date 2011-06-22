module.exports = (app) ->
    {command} = app.util
    
    loader = (nous) ->
        command nous, "unload", (input) ->
            if app.destroy[input.msg]
                try
                    app.destroy[input.msg] nous
                    response = "success unloading #{input.msg}"
                catch err
                    response = "failed to unload #{input.msg}"
            else
                response = "no plugin registered as #{input.msg}"
            nous.say input.to, response
            
    return {
        start: loader
    }
