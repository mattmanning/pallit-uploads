coffee   = require("coffee-script")
crypto   = require("crypto")
express  = require("express")
fs       = require("fs")
log      = require("./lib/logger")
storage  = require("./lib/storage").init()
util     = require("util")

require("http").globalAgent.maxSockets = 50

express.logger.format "method", (req, res) ->
  req.method.toLowerCase()

express.logger.format "url", (req, res) ->
  req.url.replace('"', '&quot')

express.logger.format "user-agent", (req, res) ->
  (req.headers["user-agent"] || "").replace('"', '')

app = express(
  express.logger
    buffer: false
    format: "subject=\"http\" method=\":method\" url=\":url\" status=\":status\" elapsed=\":response-time\" from=\":remote-addr\" agent=\":user-agent\""
  express.bodyParser())

app.get "/", (req, res) ->
  res.send "ok"

app.post "/file/:hash", (req, res) ->
  log "api.file.post", hash:req.params.hash, (logger) ->
    storage.verify_hash req.files.data.path, req.params.hash, (err) ->
      return res.send(err, 403) if err
      storage.create_stream "/hash/#{req.params.hash}", fs.createReadStream(req.files.data.path), (err) ->
        res.send "ok"

port = process.env.PORT || 5000

app.listen port, ->
  console.log "listening on port #{port}"