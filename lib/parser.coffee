twilio = require 'twilio'
dialogue = require 'dialogue'

twilioNumber = "+15186335464"
content = dialogue.defaultContent()

exports.parse = (body) ->
  name = (body.toLowerCase().split "hi my name is ")[1]
  content = dialogue.niceToMeetYou(name) if name
  content = dialog.whoAreYou()

exports.buildResponse = (fromNumber, messageBody) ->
  resp = new twilio.TwimlResponse()
  resp.sms
    from: twilioNumber
    to: fromNumber
  , messageBody