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
            help: "No help documents yet, hold tight."
            about: "Open sores coffescript/js/nodejs IRC bot maintained by eggsby and freenode#web users."
        command nous, "help", docs.help, (input) ->
            switch input.msg
                when 'plugins'
                    nous.say input.to, "#{input.from}: You can read about creating plugins here: https://github.com/eggsby/nousbot/wiki/writing-plugins"
            
        command nous, "about", docs.about, (input) ->
            switch input.msg
                when 'nousbot'
                    nous.say input.to, "#{input.from}: https://github.com/eggsby/nousbot"
            
    return {
        start: nousbot
    }
