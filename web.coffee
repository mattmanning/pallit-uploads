bouncer       = require('./lib/bouncer').init()
coffee        = require("coffee-script")
express       = require("express")
FileHandler   = require('./lib/file_handler')

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

app.post '/file', (req, res) ->
  # get the node-formidable form
  form = req.form
  form.onPart = FileHandler.basic_upload(res)

app.listen(process.env.PORT || 5000)
