Plugin = require "../lib/plugin"

info =
    name: "weather"
    trigger: "weather"
    doc: "'weather <zip|postal>' returns the current weather information"

weather = (env) ->
    match = @matchTrigger env
    if match?
        url = "http://www.google.com/ig/api?weather="
        urisafe = encodeURIComponent match
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
                response = results.city + ": " +
                           results.condition + ", " +
                           results.temp_f + "F/" +
                           results.temp_c + "C " +
                           results.humidity + ", " +
                           results.wind_condition
                @respond env, "#{response}"
            else
                @respond env, "Couldn't find any weather information for #{match}. Try a zip or postal code?"

module.exports = {
    weather: new Plugin info, weather
}
