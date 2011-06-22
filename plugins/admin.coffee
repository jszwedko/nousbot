module.exports = (app) ->
    {config} = app
    {admins} = config
    {command} = app.util
    
    admin = (nous) ->
        command nous, "kick", (input) ->
            if input.from in admins
                nous.say input.to, "screw you #{input.msg}"
                nous.send "kick", input.to, input.msg
        command nous, "ban", (input) ->
            if input.from in admins
                nous.say input.to, "gtfo #{input.msg}"
                nous.send "MODE", input.to, "+b", input.msg
                nous.send "kick", input.to, input.msg
        command nous, "unban", (input) ->
            if input.from in admins
                nous.say input.to, "mehh...."
                nous.send "MODE", input.to, "-b", input.msg
                
    return {
        start: admin
    }