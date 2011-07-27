class Redis
    constructor: (@config) ->
        @redis = require "redis"
        @client = @redis.createClient()
        @client.on "error", (err) ->
            console.log "Redis connection error to #{client.host}: #{client.port} - #{err}"

class Memstore
    constructor: ->
        @makeClient()

    makeClient: ->
        @memory = {}
        @client = {}
        @client.set = (key, val) =>
            @memory[key] = val
        @client.get = (key, cb) =>
            try
                response = @memory[key]
                cb null, response
            catch err
                cb err, null
        @client.del = (key) =>
            if @memory[key]?
                delete @memory[key]

class JStore extends Memstore
    constructor: (@filepath) ->
        @makeClient()
        @load()
        @jstore = true

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
