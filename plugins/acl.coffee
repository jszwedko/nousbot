Plugin = require "../lib/plugin"
# Require the plugin class

# Set up the info object
disable =
  name: "disable"
  trigger: "disable"
  doc: "'disable <plugin> [user]' disables plugin in the given channel"

# Set up the callback function to be called when a message is received by nous
disableCall = (env) ->
    # Check the env for a remainder after a trigger
    # If we find it, say it back to the environment
    if env.from in nous.config.admins
        match = @matchTrigger env
        if match?
            [tmp, plugin, nick] = match.match /^(\S+)\s*(.*)?\s*$/
            if plugin? and plugin in nous.sieve.map[env.to]
                if nick?
                    status = nous.sieve.addToBlacklist "users", nick, plugin
                else
                    status = nous.sieve.addToBlacklist "chans", env.to, plugin
                results = if status then "Done." else "That didn't work."
            else
                results = "#{plugin} isn't loaded in #{env.to}"
            @respond env, results


disablePlugin = new Plugin disable, disableCall

# export our new plugin
module.exports =
    disable: disablePlugin
