assert  = require('chai').assert
ostiary = require('../lib/ostiary').init()

suite 'Ostiary', () ->

  # Test that a uuid is generated and returned
  test '#create_key returns a key', (done) ->
    ostiary.create_key (err, key) ->
      assert.ok(key)
      done()

  # Test that returned key exists in redis
  test '#create_key stores a key in redis', (done) ->
    ostiary.create_key (err, key) ->
      ostiary.redis.exists key, (err, res) ->
        assert.equal 1, res
        done()
