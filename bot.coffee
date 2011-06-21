# load the project configuration
{config} = require "./config" # pull config out of config file
{network} = config # pull the values out of config 
{server, nick, opts} = network

# load project dependencies
irc = require "irc"
fs = require "fs"

# define the connection method
connect = ->
  console.log "Attempting to connect to #{server} as #{nick}"
  console.log "this may take a while..."
  new irc.Client server, nick, opts

plugins = {} # create an empty object for pushing to
do (plugins) ->
  # loop through the plugins dir
  fs.readdirSync("./plugins").forEach (plugin) ->
    # look for .coffee files
    if plugin.match /^.*\.coffee$/
      plugin = plugin.replace ".coffee", ""
      # push matched plugins
      plugins[plugin] = ->
        require "./plugins/#{plugin}"

nous = connect() # create the irc connection
for name, loader of plugins # loop over plugins
  try
    name = loader() # and load each plugin
    name.start(nous)
  catch err
    console.log "failed to load plugin #{name}"
