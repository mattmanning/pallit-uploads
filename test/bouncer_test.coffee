assert  = require('chai').assert
bouncer = require('../lib/bouncer').init()

suite 'Bouncer', () ->

  # Test that a uuid is generated and returned
  test '#create_key returns a key', (done) ->
    bouncer.create_key (err, key) ->
      assert.ok(key)
      done()

  # Test that returned key exists in redis
  test '#create_key stores a key in redis', (done) ->
    bouncer.create_key (err, key) ->
      bouncer.redis.exists key, (err, res) ->
        assert.equal 1, res
        done()
