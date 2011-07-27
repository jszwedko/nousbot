Plugin = require "../lib/plugin"

info =
    name: 'choose'
    trigger: 'choose'
    doc : 'choose <choice1>, <choice2>, ... <choicen> -- makes a decision'

choose = (env) ->

    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        choices = match.match /([^,]+)/g

        @respond env, choices[Math.floor Math.random() * choices.length]


module.exports = {
    choose: new Plugin info, choose
}
