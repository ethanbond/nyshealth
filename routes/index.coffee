Firebase = require 'firebase'
twilio = require 'twilio'
parser = require '../lib/parser'

dataRef = new Firebase("https://vera.firebaseIO.com/")

getWeights = (snapshot) ->
  vals = []
  for key, val of snapshot.val()
    for k, v of val
      if k is 'weights'
        for i, j of v
          vals.push(j.weight)
    return vals

getTimes = (snapshot) ->
  vals = []
  for key, val of snapshot.val()
    for k, v of val
      if k is 'weights'
        for i, j of v
          vals.push(j.time)
    return vals

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
      console.log resp.toString()

    console.log 'Incoming request data: '
    for k, v of req.query
      console.log k.green+v
    parser.parse(req.query.Body, req.query.From, buildResponse)
  export: (req, res)->
    urlString = req.url[1..-1]
    dataRef.once "value", (snapshot) ->
      for phoneNumber, dataSet of snapshot.val()
          for dataKey, dataPack of dataSet
            if (dataKey is 'exportURL') and (dataPack is urlString)
              res.render 'export',
                metadata:
                  title: urlString
                weights: getWeights(snapshot)
                times: getTimes(snapshot)
