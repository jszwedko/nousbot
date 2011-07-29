Plugin = require "../lib/plugin"

tagAddInfo =
    name: 'tag add'
    trigger: 'tag add'
    keyprefix: 'tag'
    doc : 'tag add <nick> <tag <, tag>*>: Associates the given tags with the given nick'

tagAdd = (env) ->
    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        console.log match
        [tmp, nick, tags] = match.match /\s*(?:add)?(.+?)\ +(.+)/

        if nick? and tags?
            prefixedTags = []
            nicks = []

            tags = for tag in tags.split ',' 
                tag.trim()

            nick = nick.trim()

            prefixedTags = for tag in tags
                "tag-#{tag.trim()}" 

            nicks = for i in [0...tags.length] #consturct same length array of prefixed nicks
                nick
            
            if prefixedTags.length > 0
                setAdd.apply this, [env, ["nick-#{nick}", prefixedTags...], [tags, nicks...], (added) => 
                    if added then @respond env, 'Tag(s) added'
                    else @respond env, 'Error adding tag(s)'
                ]
        else
            @respond env, "#{@info.doc}"

tagListInfo =
    name: 'tag list'
    trigger: 'tag list'
    keyprefix: 'tag'
    doc : 'tag list <$nick, tag> Prints the tags or nicks associated with the nick or tag respectively'

tagList = (env) ->
    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        [tmp, isnick, query] = match.match /(\$)?(.*)/

        query = query.trim()

        if query?
            if isnick
                @get env, "nick-#{query}", (err, res) =>
                    throw err if err

                    if res?
                        tags = JSON.parse res
                        if tags.length isnt 0
                            @respond env, tags.join ', '
                        else
                            @respond env, "No tags associated with nick #{query}"
                    else
                        @respond env, "No tags associated with nick #{query}"
            else
                @get env, "tag-#{query}", (err, res) =>
                    throw err if err

                    if res?
                        nicks = JSON.parse res
                        if nicks.length isnt 0
                            @respond env, nicks.join ', '
                        else
                            @respond env, "No nicks associated with tag #{query}"
                    else
                        @respond env, "No nicks associated with tag #{query}"
        else
            @respond env, "#{@info.doc}"

tagDelInfo =
    name: 'tag del'
    trigger: 'tag del'
    keyprefix: 'tag'
    doc : 'tag del <nick> <tag <, tag>*>: Disassociates the given tags with the given nick'

tagDel = (env) ->
    if @triggerOnly env
        @respond env, "#{@info.doc}"
    else if match = @matchTrigger env
        [tmp, nick, tags] = match.match /(.+?)\ +(.+)/

        if nick? and tags?
            prefixedTags = []
            nicks = []

            tags = for tag in tags.split ',' 
                tag.trim()

            nick = nick.trim()

            prefixedTags = for tag in tags
                "tag-#{tag.trim()}" 

            nicks = for i in [0...tags.length] #consturct same length array of prefixed nicks
                nick
            
            if prefixedTags.length > 0
                setDel.apply this, [env, ["nick-#{nick}", prefixedTags...], [tags, nicks...], (deleted) =>
                    if deleted then @respond env, 'Tag(s) deleted'
                    else @respond env, 'Error deleting tag(s)'
                ]
        else
            @respond env, "#{@info.doc}"

setAdd  = (env, keys, vals, callback = ->) ->
    @get env, keys, (err, res) =>
        throw err if err

        valsToSave = []

        if res?
            for i in [0...keys.length]
                res[i] ?= '[]'
                valsToSave[i] = JSON.parse res[i]

                vals[i] = [vals[i]] unless vals[i] instanceof Array

                for val in vals[i]
                    unless val in valsToSave[i]
                        valsToSave[i].push val

                valsToSave[i] = JSON.stringify valsToSave[i]
        else
            callback(false)
            return

        @set env, keys, valsToSave

        callback(true)

setDel  = (env, keys, vals, callback = ->) ->
    @get env, keys, (err, res) =>
        throw err if err

        valsToSave = []

        if res?
            for i in [0...keys.length]
                res[i] ?= '[]'
                valsToSave[i] = JSON.parse res[i]

                vals[i] = [vals[i]] unless vals[i] instanceof Array

                for val in vals[i]
                    if val in valsToSave[i]
                        valsToSave[i].splice valsToSave[i].indexOf(val), 1

                valsToSave[i] = JSON.stringify valsToSave[i]
        else
            callback(false)
            return

        @set env, keys, valsToSave

        callback(true)

module.exports = {
    tagAdd: new Plugin tagAddInfo, tagAdd
    tagList: new Plugin tagListInfo, tagList
    tagDel: new Plugin tagDelInfo, tagDel
}
