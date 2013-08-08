util = require("util")

class Storage

  constructor: () ->
    @client = require('knox').createClient
      key:    process.env.AWS_ACCESS_KEY_ID
      secret: process.env.AWS_SECRET_ACCESS_KEY
      bucket: process.env.S3_BUCKET

  write_stream: (stream, file_length, cb) ->
    headers = {
      'Content-Type': stream.mime
      'Content-Length': file_length
    }

    s3req = @client.putStream stream, stream.filename, headers, (err, s3res) ->
      throw err if err
      console.log s3res.statusCode
      console.log s3res.headers
      s3res.pipe process.stdout, {end: false}
      console.error 's3 callback', s3req.url
      cb s3req.url

    s3req.on 'progress', (data) ->
      console.log(util.inspect(data) + "\n")
    
module.exports.init = () ->
  new Storage()