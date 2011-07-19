Plugin = require "../lib/plugin"

info =
    name: "lastfm"
    trigger: "lastfm"
    doc: "'lastfm <user>' gets the last scrobbled track from last.fm"

lastfm = (env) ->
    match = @matchTrigger env
    if match?
        url = """
            http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=
            #{encodeURIComponent match}&api_key=#{nous.config.apikeys.lastfm}
        """
        url = url.replace /(\r\n|\n|\r)/gm,"" # stupid heredoc.... remove newlines
        @scrape url, (err, $, data) =>
            if err
                @say env, "Sorry, couldn't find lastfm user #{match}"
            else
                response = @xml data if data
                if response?.recenttracks?.track?[0]?
                    user = response.recenttracks["@"].user
                    track = response.recenttracks.track[0]
                    artist = track.artist["#"]
                    title = track.name
                    album = track.album["#"]
                    # date = track.date["#"]
                    # todo: calculate timesince last scrobble
                    response = "#{user} last played the track #{title} " +
                               "from the album #{artist} - #{album}"
                else
                    response = "#{match} has no scrobbled tracks."
                @say env, response
                

if nous.config.apikeys?.lastfm?
    module.exports = {
        lastfm: new Plugin info, lastfm
    }
else
    console.log "No apikey set for lastfm, not enabling lastfm plugin."
