coffee        = require("coffee-script")
express       = require("express")
fs            = require("fs")
util          = require("util")
StringDecoder = require('string_decoder').StringDecoder

knox = require('knox').createClient
  key:    process.env.AWS_ACCESS_KEY_ID
  secret: process.env.AWS_SECRET_ACCESS_KEY
  bucket: process.env.S3_BUCKET

app = express()
app.use(express.bodyParser({'defer': true}))

app.get "/", (req, res) ->
  res.send "ok"

app.post '/file', (req, res) ->
  # get the node-formidable form
  form = req.form
  file_length = ''
  form.onPart = (part) ->
    if (!part.filename && (part.name == 'fsize'))
      value = ''
      decoder = new StringDecoder(this.encoding);
      part.on('data', (buffer) ->
        value += decoder.write(buffer))
      part.on('end', () ->
        file_length = value)
      return

    progress = 0

    headers = {
      'Content-Type': part.mime
      'Content-Length': file_length
    }

    s3req = knox.putStream part, part.filename, headers, (err, s3res) ->
      throw err if err
      console.log(s3res.statusCode)
      console.log(s3res.headers)
      s3res.pipe(process.stdout, {end: false})
      console.error('s3 callback', s3req.url)
      res.status(201).send(s3req.url)

    s3req.on('progress', console.log);

    part.on('data', (buffer) ->)
      # console.log(progress += buffer.length))

    part.on('end', () ->)

port = process.env.PORT || 5000

app.listen port, ->
  console.log "listening on port #{port}"