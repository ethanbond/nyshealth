twilio = require 'twilio'
dialog = require 'dialog'

twilioNumber = "+15186335464"
content = dialog.defaultContent()

exports.parse = (body) ->
  name = (body.toLowerCase().split "hi my name is ")[1]
  if name
    content = dialog.niceToMeetYou(name)
    return content
  content = dialog.whoAreYou()

exports.buildResponse = (fromNumber, messageBody) ->
  resp = new twilio.TwimlResponse()
  resp.sms
    from: twilioNumber
    to: fromNumber
  , messageBody