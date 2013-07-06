coffee    = require("coffee-script")
express   = require("express")
fs        = require("fs")
util      = require("util")

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
  form.onPart = (part) ->
    if (!part.filename)
      # let formidable handle all non-file parts
      form.handlePart(part)

    @_flushing++
    progress = 0

    headers = {
      'Content-Type': part.mime
      'Content-Length': '5660375'
    }

    knox.putStream part, part.filename, headers, (err) ->
      res.send "ok"

    part.on('data', (buffer) ->
      console.log(progress += buffer.length))

    part.on('end', () ->
      @_flushing--)

port = process.env.PORT || 5000

app.listen port, ->
  console.log "listening on port #{port}"