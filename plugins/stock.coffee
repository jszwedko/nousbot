module.exports = (app) ->
    {command, parse} = app.util
    
    stock = (nous) ->
        command nous, "stock", (input) ->
            url = "http://www.google.com/ig/api?stock=#{input.msg}"
            parse url, (err, $, data) ->
                
                company = ($ "company").attribs.data
                latest = ($ "last").attribs.data
                ticker = ($ "symbol").attribs.data
                change = ($ "change").attribs.data
                
                text = if latest and company
                    "#{company} (#{ticker}): $#{latest} (#{change})" 
                else
                    "Couldn't get the value of ticker symbol #{input.msg}"
                nous.say input.to, text

    return {
        start: stock
    }
