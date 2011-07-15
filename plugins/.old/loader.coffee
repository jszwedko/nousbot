module.exports = (app) ->
    {command} = app.util
    {admins} = app.config
    
    loader = (nous) ->
        command nous, "unload", (input) ->
            if input.from in admins
                if app.destroy[input.msg]
                    # this isn't quite right... it only removes the listener
                    # it doesn't remove the required plugin cache
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
                    # likewise, this only adds the listeners
                    # what it should be doing is checking for a require
                    # nullifying that require, and re-requiring... THEN load
                    try
                        app.plugins[input.msg].start nous
                        response = "success loading #{input.msg}"
                    catch err
                        response = "failed to load #{input.msg}"
                else
                    # why should it need to be registered?
                    # use this statement to load unrequired plugins...
                    response = "no plugin registered as #{input.msg}"
                nous.say input.to, response
            
    return {
        start: loader
    }
