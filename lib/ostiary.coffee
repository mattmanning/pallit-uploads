uuid = require('node-uuid')

class Ostiary

  constructor: () ->
    if (process.env.REDISTOGO_URL)
      rtg   = require("url").parse(process.env.REDISTOGO_URL)
      @redis = require("redis").createClient(rtg.port, rtg.hostname)
      @redis.auth(rtg.auth.split(":")[1])
    else
      @redis = require("redis").createClient()

  create_key: (cb) ->
    key = uuid.v4()
    @redis.setex key, 1800, '', (err, reply) ->
      cb null, key

module.exports.init = () ->
  new Ostiary()