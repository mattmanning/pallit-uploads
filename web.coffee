bouncer       = require('./lib/bouncer').init()
coffee        = require("coffee-script")
express       = require("express")
storage       = require('./lib/storage').init()
StringDecoder = require('string_decoder').StringDecoder

app = express()
app.use(express.bodyParser({'defer': true}))

app.all '/*', (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  next()

app.options '/file', (req, res) ->
  res.send 200, 'OK'

app.get '/', (req, res) ->
  res.send "ok"

app.post '/key', (req, res) ->
  bouncer.create_key (err, key) ->
    if err
      res.send(400, err)
    else
      res.send(201, key)

part_handler = (res) ->
  (part) ->
    if (!part.filename && (part.name == 'file-size'))
      value = ''
      decoder = new StringDecoder(this.encoding);
      part.on('data', (buffer) ->
        value += decoder.write(buffer))
      part.on('end', () ->
        file_length = value)
      return

    res.writeHead(200, {'Content-Type': 'text/html'})

    storage.write_stream part, file_length, (url) ->
      res.write(url)
      res.end

    progress = 0

    part.on('data', (buffer) ->
      # keep the connection alive
      res.write('')
      console.log(progress += buffer.length))
    
    part.on('end', () ->)

app.post '/file', (req, res) ->
  # get the node-formidable form
  form = req.form
  file_length = ''
  form.onPart = part_handler(res)

app.listen(process.env.PORT || 5000)
