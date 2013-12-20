twilio = require 'twilio'
parser = require '../lib/parser'

module.exports =
  index: (req, res)->
    res.send 'Nothing ot see here'
  twil: (req, res)->
    buildResponse = (fromNumber, messageBody) ->
      twilioNumber = "+15186335464"
      resp = new twilio.TwimlResponse()
      resp.sms
        from: twilioNumber
        to: fromNumber
      , messageBody
      res.writeHead 200,
        "Content-Type": "text/xml"
      res.end resp.toString()

    console.log 'Incoming request data: '
    for k, v of req.query
      console.log k.green+v
    parser.parse(req.query.Body, req.query.From, buildResponse)
