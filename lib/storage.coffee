class Storage #I'm an abstract class
    get: (keys, cb) -> throw 'Not implemented'
    set: (keys, vals) -> throw 'Not implemented'
    del: (keys) -> throw 'Not implemented'

    startTransaction: -> throw 'Not implemented'
    rollback: -> throw 'Not implemented'
    commit: -> throw 'Not implemented'


class Redis extends Storage
    constructor: (@config) ->
        @redis = require "redis"
        @makeClient()

    makeClient: ->
        @client = @redis.createClient()
        @client.on "error", (err) ->
            console.log "Redis connection error to #{client.host}: #{client.port} - #{err}"


    get: (keys, cb) ->
        @client.mget keys, (err, res) => 
            if keys.length is 1
                cb err, res[0]
            else
                cb err, res

    set: (keys, vals) ->
        if keys.length isnt vals.length
            throw 'Keys and vals are not the same length'

        console.log keys
        console.log vals

        keyVals = []

        for i in [0...keys.length]
            keyVals.push keys[i]
            keyVals.push vals[i]

        console.log keyVals
        @client.mset keyVals, (err, res) -> throw err if err

    del: (keys) ->
        @client.del = (keys) => redis.mget keys, (err, res) -> throw err if err

    startTransaction: -> #eventually throw a warning
    rollback: (cb) -> #eventually throw a warning
    commit: (cb) -> #eventually throw a warning

class Memstore extends Storage
    constructor: ->
        @makeClient()

    makeClient: ->
        @memory = {}

    get: (keys, cb) ->
        vals = []

        try
            for key in keys
                vals.push @memory[key]
        catch err
            cb err, null
            return

        cb null, vals

    set: (keys, vals) ->
        if keys.length isnt vals.length
            throw 'Keys and vals are not the same length'

        for i in [0...keys.length]
            @memory[key] = val

    del: (keys) ->
        for key in keys
            if @memory[key]?
                delete @memory[key]

    startTransaction: -> #eventually throw a warning
    rollback: (cb) -> #eventually throw a warning
    commit: (cb) -> #eventually throw a warning

class JStore extends Memstore
    constructor: (@filepath) ->
        @makeClient()
        @load()
        @jstore = true

    get: (keys, cb) ->
        vals = []

        try
            for key in keys
                vals.push @memory[key]
        catch err
            cb err, null
            return

        cb null, vals

    save: ->
        nous.fs.writeFile "#{@filepath}", (JSON.stringify @memory), (err) ->
            if err
               return false

    load: ->
        nous.fs.readFile "#{@filepath}", (err, data) =>
            if data?
                for key, value of JSON.parse data
                    @memory[key] = value

module.exports =
    Redis: Redis
    JStore: JStore
    Memstore: Memstore
