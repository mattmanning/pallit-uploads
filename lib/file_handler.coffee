storage       = require('./storage').init()
StringDecoder = require('string_decoder').StringDecoder

file_length = ''

get_file_size = (part) ->
  if (part.name == 'file-size')
    value = ''
    decoder = new StringDecoder(this.encoding);
    part.on 'data', (buffer) ->
      value += decoder.write(buffer)
    part.on 'end', () ->
      file_length = value

module.exports.basic_upload = (res) ->
  (part) ->
    if (part.filename)
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

    else
      get_file_size(part)
