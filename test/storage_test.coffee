assert  = require('chai').assert
storage = require('../lib/storage').init()

suite 'Storage', () ->

  test 'constructor creates S3 client', () ->
    assert.ok(storage.client)

