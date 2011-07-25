Plugin = require "../lib/plugin"
# Require the plugin class

# Set up the info object
info =
  name: "echo"
  trigger: "echo"
  doc: "'echo <msg>' echos msg to the channel"

# Set up the callback function to be called when a message is received by nous
echo = (env) ->
    # Check the env for a remainder after a trigger
    match = @matchTrigger env
    # If we find it, say it back to the environment
    if match?
        @say env, match

echoPlugin = new Plugin info, echo

# export our new plugin
module.exports =
    echo: echoPlugin

# TESTING
# TestBot = require "../lib/testbot" # let's test our plugin...
# nous = new TestBot echoPlugin
# testEnv =
#     message: ".echo string"
#     from: "eggsby"
#     to: "#web"
# nous.test testEnv
