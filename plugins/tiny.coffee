module.exports = (app) ->
    {command, parse} = app.util

    tiny = (nous) ->
        command nous, "tiny", (input) ->
            url = "http://tinyurl.com/api-create.php?url=#{input.msg}"
            parse url, (err, $, data) ->
                selector = "body"
                quote = $(selector)?.text
                nous.say input.to, quote

    return {
        start: tiny
    }

