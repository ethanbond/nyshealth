Firebase = require 'firebase'
twilio = require 'twilio'
parser = require '../lib/parser'

dataRef = new Firebase("https://vera.firebaseIO.com/")

getBMIs = (phoneRef) ->
  [20, 19, 18, 20]

getTimes = (phoneRef) ->
  [1, 2, 3, 4]

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
  export: (req, res)->
    urlString = req.url[1..-1]
    dataRef.once "value", (snapshot) ->
      for phoneNumber, dataSet of snapshot.val()
          for dataKey, dataPack of dataSet
            if (dataKey is 'export') and (dataPack is urlString)
              console.log getBMIs(dataRef.child(phoneNumber))
              res.render 'export',
                metadata: 
                  title: urlString
                bmis: getBMIs(dataRef.child(phoneNumber))
                times: getTimes(dataRef.child(phoneNumber))