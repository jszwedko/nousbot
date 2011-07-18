var Plugin, info, square;
// set up the variables we'll be using

// bring the plugin class into the modules scope
Plugin = require("../lib/plugin");

// set up an info object for the plugin
// the only required attribute is name, but the others are useful
info = {
  name: "square",
  trigger: "sqr", // trigger is used by matchTrigger or triggerOnly
  doc: "'sqr <number>' returns the squares of a number" // doc is used by the help plugin
};

// set up a function to be run when a message is recieved by the bot
// the function must expect an env variable
// which contains information about the context the plugin was called in
// (who called it, where it was called from, what the msg is, etc)
square = function(env) {
  var match;
  // plugins are run in the Plugin namespace, so "this" refers to the plugin class
  // matchTrigger returns everything after the trigger (requires info.trigger to work)
  match = this.matchTrigger(env);
  if (match != null) {
    if (isNaN(parseInt(match))) {
      // We want to make sure the matched information is a number
      // If it isn't we will say our error message to the environment
      return this.say(env, "Square needs to be passed an integer...");
    } else {
      // If we know it is a number, we can do our work and say it to the env
      return this.say(env, match * match);
    }
  }
};

// finally, set up the plugin as a namespace in our module
module.exports = {
  square: new Plugin(info, square)
};
