Plugin = require "../lib/plugin"

info =
    name: "google"
    trigger: "google"
    doc: "'google <query>' -- returns a result for the given query"

googleurl = (service, query) ->
    query = encodeURIComponent query
    "http://ajax.googleapis.com/ajax/services/search/#{service}?v=1.0&safe=off&q=#{query}"


google = (env) ->
    query = @matchTrigger env
    if query?
        url = googleurl "web", query
        @scrape url, (err, $, data) =>
            response = JSON.parse data
            if response?.responseData?.results[0]?
                result = response.responseData.results[0]
                result[x] = unescape x for x in result
                {titleNoFormatting, content, unescapedUrl} = result
                content = @cleanHTML content
                results = "#{unescapedUrl} - #{titleNoFormatting} -- #{content}"
            else
                results = "No results found for #{query}."
            @respond env, results
            

module.exports = {
    google: new Plugin info, google
}
