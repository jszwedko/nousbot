module.exports = (app) ->

    return {
        config: app.config
        admins: app.config.admins
        
        start: (nous) ->
            app.util.command nous, "kick", (input) ->
                if input.from in admins
                    nous.say input.to, "screw you #{input.msg}"
                    nous.send "kick", input.to, input.msg
            app.util.command nous, "ban", (input) ->
                if input.from in admins
                    nous.say input.to, "gtfo #{input.msg}"
                    nous.send "MODE", input.to, "+b", input.msg
                    nous.send "kick", input.to, input.msg
            app.util.command nous, "unban", (input) ->
                if input.from in admins
                    nous.say input.to, "mehh...."
                    nous.send "MODE", input.to, "-b", input.msg
    }