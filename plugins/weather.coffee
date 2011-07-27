Plugin = require "../lib/plugin"

info =
    name: "weather"
    trigger: "weather"
    doc: "'weather <<zip|postal> [dontsave] | $nick>' returns the current weather information for given location or location associated with the given nick"

weather = (env) ->
    # attempt to scrape a location from the google weather apis
    getWeather = (location, callback) =>
        if location?
            url = "http://www.google.com/ig/api?weather="
            urisafe = encodeURIComponent location
            url = "#{url}#{urisafe}"

            @scrape url, (err, $, data) =>
                throw err if err
                conditions = @xml data
                if conditions?.weather?.forecast_information?.city?
                    results = {}
                    grab = ["condition", "temp_f", "temp_c", "humidity", "wind_condition"]
                    for x in grab
                        try
                            results[x] = conditions.weather.current_conditions[x]["@"].data
                        catch err
                            results[x] = ""
                    results["city"] = conditions.weather.forecast_information.city["@"].data
                callback location, results

    # say the results of a weather scrape to the channel
    printWeather = (location, results) =>
        if results?
            response = results.city + ": " +
                       results.condition + ", " +
                       results.temp_f + "F/" +
                       results.temp_c + "C " +
                       results.humidity + ", " +
                       results.wind_condition
        else
            response = "Couldn't find any weather information for #{location}. Try a zip or postal code?"
        @respond env, response

    # begin testing input
    if @triggerOnly env
        dontsave = true

        @get env, "weather-#{env.from}", (err, res) =>
            if res?
                getWeather res, printWeather
            else
                @respond env, @info.doc
    else
        match = @matchTrigger env

    if match?
        [tmp, isnick, query, dontsave] =  match.match /^(\$)?(.*?)(dontsave)?\s*$/
        query = query.trim()

        if isnick?
            # This will only be reached if $<query> was matched
            dontsave = true
            @get env, "weather-#{query}", (err, res) =>
                if res?
                    getWeather res, printWeather
                else
                    @respond env, "No remembered location for #{query}"
        else
            getWeather query, printWeather

        if not dontsave?
            @set env, "weather-#{env.from}", query

module.exports = {
    weather: new Plugin info, weather
}
