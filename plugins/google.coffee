module.exports = (app) ->
    url = (service, query) ->
        query = encodeURIComponent query
        "http://ajax.googleapis.com/ajax/services/search/#{service}" +
        "?v=1.0&safe=off&q=#{query}"
    
    search = (nous) ->
        doc = "!google <query> -- searches google for the given query."
        u.command nous, "google", doc, (input) ->
            results = null
            searchURL = url "web", input.msg
            u.parse searchURL, (err, $, data) ->
                response = JSON.parse data
                if response.responseData?.results?
                    result = response.responseData.results[0]
                    result[x] = unescape x for x in result
                    {titleNoFormatting, content, unescapedUrl} = result
                    content = u.striptags content
                    results = "#{unescapedUrl} - #{titleNoFormatting} -- #{content}"
                else
                    results = "something else."
                nous.say input.to, results

    return {
        start: search
    }
