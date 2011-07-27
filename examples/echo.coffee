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
    match = Plugin.prototype.matchTrigger.apply this, [env]
    # If we find it, say it back to the environment
    if match?
        Plugin.prototype.respond env, match

echoPlugin = new Plugin info, echo

# export our new plugin
module.exports =
    echo: echoPlugin

# TESTING
TestBot = require "../lib/testbot" # let's test our plugin...
nous = new TestBot echoPlugin
# this one should pass
testEnv =
    message: ".echo string test one"
    from: "eggsby"
    to: "#web"

# this should fail
testEnv2 =
    message: ".echo"
    from: "eggsby"
    to: "#web"
nous.test testEnv, testEnv2
