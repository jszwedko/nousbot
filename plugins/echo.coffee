Plugin = require "../lib/plugin"

info =
  name: "echo"
  trigger: "echo"
  doc: "'echo <msg>' echos msg to the channel"

echo = (env) ->
    match = @matchTrigger env
    if match?
        @say env, match

module.exports =
    echo: new Plugin info, echo
