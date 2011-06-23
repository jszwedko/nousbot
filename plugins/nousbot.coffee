###
 *********************************************************************
 * @file        nousbot.coffee
 * @author      joshmanders
 * @url         joshmanders.com
 * @email       josh@joshmanders.com
 * @description Random commands that pertain to nousebot.
 *********************************************************************
###

module.exports = (app) ->
    {command} = app.util
    
    nousbot = (nous) ->
        docs =
            help: "!help [plugins] -- show help information"
            about: "Open sores coffescript/js/nodejs IRC bot maintained by eggsby and freenode#web users."

        command nous, "help", docs.help, (input) ->
            reply = "#{input.from}: No help documents for #{input.msg}"
            switch input.msg
                when 'plugins'
                    reply = "#{input.from}: You can read about creating plugins here: https://github.com/eggsby/nousbot/wiki/writing-plugins"
            nous.say input.to, reply
            
        command nous, "about", docs.about, (input) ->
            reply = "#{input.from}: No information about #{input.msg}"
            switch input.msg
                when 'nousbot'
                    reply = "#{input.from}: https://github.com/eggsby/nousbot"
            nous.say input.to, reply
            
    return {
        start: nousbot
    }
