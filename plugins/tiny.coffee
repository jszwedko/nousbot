module.exports = (app) ->
    {command, parse} = app.util

    doc = "!tiny <url> -- sends the url to tinyurl to be shortened."
    tiny = (nous) ->
        command nous, "tiny", doc, (input) ->
            url = "http://tinyurl.com/api-create.php?url=#{input.msg}"
            parse url, (err, $, data) ->
                nous.say input.to, data

    return {
        start: tiny
    }

