###
 *********************************************************************
 * @file        memes.coffee
 * @author      joshmanders
 * @url         joshmanders.com
 * @email       josh@joshmanders.com
 * @description TROLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOL...
 *********************************************************************
###

module.exports = (app) ->
    {command, parse} = app.util
    
    memes = (nous) ->
        command nous, "derp", docs=false, (input) ->
            parse "http://api.automeme.net/text?lines=1", (err, $, data) ->
                nous.say input.to, data
            
    return {
        start: memes
    }
