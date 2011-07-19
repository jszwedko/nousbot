Plugin = require "../lib/plugin"

info =
  name: "help"
  trigger: "help"
  doc: "does helpful stuff, call 'help <plugin>' for help on a specific plugin" +
       " or 'help all' for more information"

help = (env) ->
    if @triggerOnly env
        @respond env, @info.doc
    else
        match = @matchTrigger env
        if match?
            helpdoc =
                if nous.plugins[match]?.info?.doc?
                    nous.plugins[match].info.doc
                else
                    null
            if helpdoc
                @respond env, helpdoc
            else if match is "all"
                @respond env, "nousbot is an open source bot written in coffeescript, " +
                     "maintained by members of freenode#web. https://github.com/eggsby/nousbot/"
                if nous.sieve.map[env.to]?
                    list = nous.sieve.map[env.to].join ", "
                else
                    list = (k for k of nous.plugins).join ", "
                @respond env, "Plugins enabled in #{env.to}: #{list}"
            else
                @respond env, "Oops, couldn't find any help for #{match}"

module.exports =
    help: new Plugin info, help
