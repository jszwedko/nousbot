Plugin = require "../lib/plugin"

info =
    name: "wikipedia"
    trigger: "wiki"
    doc: "'wiki <query>' -- returns a Wikipedia excerpt for the given query"

wikiurl = (query) ->
    query = encodeURIComponent query
    "http://en.wikipedia.org/w/api.php?action=opensearch&format=xml&search=#{query}"


wikipedia = (env) ->
    query = @matchTrigger env
    if query?
        url = wikiurl query
        console.log url
        @scrape url, (err, $, data) =>
            message = ""
            if err
                message = "Sorry, couldn't find any results for #{query}"
            else
                response = @xml data if data

                console.log response.Section.Item.Description

                if item = response?.Section?.Item?[0] ? response?.Section?.Item
                    message = "#{item.Description?['#'][..200]} [#{item.Url?['#']}]"
                else
                    message = "Sorry, couldn't find any results for #{query}"

                @say env, message

wikipediaPlugin = new Plugin info, wikipedia


module.exports = {
    wikipedia: wikipediaPlugin
}
