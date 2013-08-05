coffee        = require("coffee-script")
express       = require("express")
fs            = require("fs")
StringDecoder = require('string_decoder').StringDecoder
util          = require("util")
ostiary       = require('./lib/ostiary').init()

knox = require('knox').createClient
  key:    process.env.AWS_ACCESS_KEY_ID
  secret: process.env.AWS_SECRET_ACCESS_KEY
  bucket: process.env.S3_BUCKET

app = express()
app.use(express.bodyParser({'defer': true}))

app.all '/*', (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  next()

app.get '/', (req, res) ->
  res.send "ok"

app.post '/key', (req, res) ->
  ostiary.create_key (err, key) ->
    if err
      res.send(400, err)
    else
      res.send(201, key)

app.post '/file', (req, res) ->
  # get the node-formidable form
  form = req.form
  file_length = ''
  form.onPart = (part) ->
    if (!part.filename && (part.name == 'file-size'))
      value = ''
      decoder = new StringDecoder(this.encoding);
      part.on('data', (buffer) ->
        value += decoder.write(buffer))
      part.on('end', () ->
        file_length = value)
      return

    progress = 0

    res.writeHead(200, {'Content-Type': 'text/html'})

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
      res.write(s3req.url)
      res.end()

    s3req.on('progress', (data) ->
      res.write(data + "\n"))

    part.on('data', (buffer) ->
      # keep the connection alive
      res.write('')
      console.log(progress += buffer.length))
    
    part.on('end', () ->)

app.listen(process.env.PORT || 5000)
