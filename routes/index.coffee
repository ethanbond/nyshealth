twilio = require 'twilio'
parser = require '../lib/parser'

module.exports =
  index: (req, res)->
    res.send 'Nothing ot see here'
  twil: (req, res)->
    console.log 'Incoming request data: '
    for k, v of req.query
      console.log k.green+v
    content = parser.parse(req.query.Body)
    resp = parser.buildResponse(req.query.From, content)
    res.writeHead 200,
      "Content-Type": "text/xml"
    res.end resp.toString()
