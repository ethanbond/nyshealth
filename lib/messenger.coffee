 module.exports =
  sendMessage: (phoneNumber, messageBody) -> 
      # We know this is bad... #hackathon
      accountSid = "AC49a0f05f5017e622beda1144f99559f0"
      authToken = "9891f1ca7a89539e1f62966bcf7bc8e9"
      twilioNumber = "+15186335464"
      client = require("twilio")(accountSid, authToken)
      client.messages.create
        body: messageBody
        to: phoneNumber
        from: twilioNumber
      , (err, message) ->
        console.log err