twilio = require 'twilio'

module.exports =
  index: (req, res)->
    res.send 'Nothing ot see here'
  twil: (req, res)->
    resp = new twilio.TwimlResponse()
    resp.sms
      from: "+15186335464"
      to: "+13014672873"
    , "You suck"
    res.writeHead 200,
      "Content-Type": "text/xml"
    res.end resp.toString()
