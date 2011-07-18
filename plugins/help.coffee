Plugin = require "../lib/plugin"

info =
  name: "help"
  trigger: "help"
  doc: "does helpful stuff, call help <plugin> for help on a specific plugin"

help = (env) ->
    if @triggerOnly env
        @say env, @info.doc
    else
        match = @matchTrigger env
        if match?
            helpdoc =
                if nous.plugins[match]?.info?.doc?
                    nous.plugins[match].info.doc
                else
                    null
            if helpdoc
                @say env, helpdoc
            else
                @say env, "Oops, couldn't find any help for #{match}"

module.exports =
    help: new Plugin info, help
