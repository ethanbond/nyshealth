twilio = require 'twilio'

module.exports =
  index: (req, res)->
    res.send 'Nothing ot see here'
  twil: (req, res)->
    resp = new twilio.TwimlResponse()
    console.log 'Incoming request data: '
    for k, v of req.query
      console.log k.green+v
    resp.sms
      from: "+15186335464"
      to: req.query.From
    , req.query.Body + " is what you said. Fuck off"
    res.writeHead 200,
      "Content-Type": "text/xml"
    res.end resp.toString()
