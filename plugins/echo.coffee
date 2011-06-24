module.exports = (app) ->
# Every plugin must be a function that expects an argument.
# Here, we name that argument "app".
    {command} = app.util
    # The application itself has numerous utilities.
    # One of which is the command utility, used to command a bot instance to listen for a trigger, and to call a callback method upon a match.
    
    echo = (nous) ->
        # Define a variable named "echo" to be passed a bot instance.
        doc = "!echo <string> -- echos a given string in channel"
        # Declare a documentation string to be returned on an empty trigger. e.g. "!echo"
        command nous, "echo", doc, (input) ->
            # Call the command method we pulled from the utility belt earlier.
            # Pass it the bot instance (nous), the trigger ("echo"), the documentation string, and finally a callback to be called upon matches.  The callback must expect one argument, the matched user input object.
            # The input object contains three attributes, from (user), to (chan), msg (matched string).
            nous.say input.to, input.msg
            # Since we only want to echo, call the bots say command, and pass it the arguments input.to (the channel to send it to) and input.msg (the matched string from the user.)
            
    return {
        # Finally, we need to return an object.
        start: echo
        # The objects start attribute must be equal to our plugin method.
    }
