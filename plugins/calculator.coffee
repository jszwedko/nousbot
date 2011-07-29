Plugin = require "../lib/plugin"

info =
    name: 'calculator'
    trigger: 'calc'
    doc : 'calc <term> -- returns Google Calculator result'

calculator = (env) ->

    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        url = 'http://www.google.com/search?q='
        urisafe = encodeURIComponent match
        url = "#{url}#{urisafe}"

        @scrape url, (err, $, data) =>
            throw err if err

            #borrowed from https://github.com/rmmh/skybot/blob/master/plugins/gcalc.py
            try
                response = $('.r')?.fulltext

            if !response?
                try
                    response = $('.r')?.first()?.fulltext

            if response?
                response = response \
                    .replace(' &#215; 10<sup>', 'E', 'g') \
                	.replace('</sup>', '', 'g') \
                	.replace('<font size=-2> </font>', ',', 'g') \
                	.replace('\xa0', ',', 'g')
            else
                response = 'Could not calculate ' + match
            
            @respond env, response

module.exports = {
    calculator: new Plugin info, calculator
}
