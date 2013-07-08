coffee        = require("coffee-script")
express       = require("express")
fs            = require("fs")
StringDecoder = require('string_decoder').StringDecoder
util          = require("util")
uuid          = require('node-uuid')

app = express()

app.use(express.bodyParser({'defer': true}))

http    = require('http')
server  = http.createServer(app)
io      = require('socket.io').listen(server)

server.listen(process.env.PORT || 5000)

knox = require('knox').createClient
  key:    process.env.AWS_ACCESS_KEY_ID
  secret: process.env.AWS_SECRET_ACCESS_KEY
  bucket: process.env.S3_BUCKET

io.sockets.on('connection', (socket) ->
  upload_id = uuid.v4()
  socket.join(upload_id)
  socket.emit('upload_id', upload_id)
  console.log('A socket connected!'))

app.get "/", (req, res) ->
  res.send "ok"

app.post '/file/:upload_id', (req, res) ->
  upload_id = req.params.upload_id
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
      io.sockets.in(upload_id).emit('progress', data))

    part.on('data', (buffer) ->
      # keep the connection alive
      res.write('')
      console.log(progress += buffer.length))
    
    part.on('end', () ->)