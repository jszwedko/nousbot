/* 
 * weather.js, written by joshmanders
 * adapted by eggsby
 * pulls out xml data from google apis
*/

module.exports = function(app) {
  var command, xml, parse, weather;

  command = app.util.command;
  parse = app.util.parse;
  xml = app.util.xml;

  weather = function(nous) {
    var doc = "!weather <city|postal code> -- returns the current weather."
    return command(nous, "weather", doc, function(input) {
      var url, urisafe;

      urisafe = encodeURIComponent(input.msg);
      url = "http://www.google.com/ig/api?weather=" + urisafe;

      return parse(url, function(err, $, data) {
        var response;
        try {
          var results = {}, city, conditions, grab;

          grab = ["condition", "temp_f", "temp_c", "humidity", "wind_condition"];
          conditions = xml(data);
          city = conditions.weather.forecast_information.city["@"]["data"];

          for (var i = 0, len = grab.length; i < len; i++) {
            results[grab[i]] = conditions.weather.current_conditions[grab[i]]["@"]["data"]
          };

          if(results.condition) {
            response = input.from + ": " + 
                       city + ": " + 
                       results.condition + ", " + 
                       results.temp_f + "F/" +
                       results.temp_c + "C " +
                       results.humidity + ", " +
                       results.wind_condition;
          };
        } catch (err) {
            response = "Sorry we couldn't find any weather info for " + input.msg;
        };
        return nous.say(input.to, response);
      });
    });
  };

  return {
    start: weather
  };
};
