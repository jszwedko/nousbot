module.exports = (app) ->
    {config} = app
    {admins} = config
    {command} = app.util
    
    admin = (nous) ->
        command nous, "kick", (input) ->
            if input.from in admins
                match = input.msg.match /([\w-]+)\ ?(.*)/
                if match.length > 2 and match[2]
                    user = match[1]
                    reason = match[2]
                else
                    user = match[1]
                    reason = "you are a terrible person"
                nous.say input.to, "screw you #{user}"
                nous.send "kick", input.to, user, reason
        command nous, "ban", (input) ->
            if input.from in admins
                match = input.msg.match /([\w-]+)\ ?(.*)/
                if match.length > 2 and match[2]
                    user = match[1]
                    reason = match[2]
                else
                    user = match[1]
                    reason = "and stay out!"
                nous.say input.to, "gtfo #{input.msg}"
                nous.send "MODE", input.to, "+b", user, reason
                nous.send "kick", input.to, user, reason
        command nous, "unban", (input) ->
            if input.from in admins
                nous.say input.to, "mehh...."
                nous.send "MODE", input.to, "-b", input.msg
                
    return {
        start: admin
    }
