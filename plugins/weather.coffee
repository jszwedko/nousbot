Plugin = require "../lib/plugin"

info =
    name: "weather"
    trigger: "weather"
    doc: "'weather <zip|postal> [dontsave]' returns the current weather information"


weather = (env) ->
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
                else
                    callback location, null

    printWeather = (location = "", results = null) =>
        if results?
            response = results.city + ": " +
                       results.condition + ", " +
                       results.temp_f + "F/" +
                       results.temp_c + "C " +
                       results.humidity + ", " +
                       results.wind_condition

            @respond env, "#{response}"
        else
            @respond env, "Couldn't find any weather information for #{location}. Try a zip or postal code?"

    if @triggerOnly env
        dontsave = true

        @get env, "weather-#{env.from}", (err, res) =>
            location = res unless @isEmptyObject res
            if location?
                getWeather location, (location, results) -> printWeather location, results
            else
                @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        [tmp, location, dontsave] =  match.match /^(.*?)(dontsave)?\s*$/
        location = location.trim()

        getWeather location, (location, results) -> printWeather location, results
    
    @set env, "weather-#{env.from}", location unless dontsave

module.exports = {
    weather: new Plugin info, weather
}
