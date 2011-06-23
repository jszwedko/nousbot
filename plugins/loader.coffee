module.exports = (app) ->
    {command} = app.util
    {admins} = app.config
    
    loader = (nous) ->
        command nous, "unload", (input) ->
            if input.from in admins
                if app.destroy[input.msg]
                    try
                        app.destroy[input.msg] nous
                        response = "success unloading #{input.msg}"
                    catch err
                        response = "failed to unload #{input.msg}"
                else
                    response = "no plugin registered as #{input.msg}"
                nous.say input.to, response
        command nous, "load", (input) ->
            if input.from in admins
                if app.plugins[input.msg]
                    try
                        app.plugins[input.msg].start nous
                        response = "success loading #{input.msg}"
                    catch err
                        response = "failed to load #{input.msg}"
                else
                    response = "no plugin registered as #{input.msg}"
                nous.say input.to, response

            
    return {
        start: loader
    }
