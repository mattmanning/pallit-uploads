coffee   = require("coffee-script")
express  = require("express")
fs       = require("fs")
util     = require("util")

knox = require('knox').createClient
  key:    process.env.AWS_ACCESS_KEY_ID
  secret: process.env.AWS_SECRET_ACCESS_KEY
  bucket: process.env.S3_BUCKET

app = express()

app.use(express.bodyParser())

app.get "/", (req, res) ->
  res.send "ok"

app.post "/file", (req, res) ->
  headers = {
    'Content-Length': req.files.data.size
    'Content-Type': req.files.data.type
  }
  knox.putStream fs.createReadStream(req.files.data.path), req.files.data.name, headers, (err) ->
    res.send "ok"

port = process.env.PORT || 5000

app.listen port, ->
  console.log "listening on port #{port}"