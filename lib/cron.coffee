Firebase = require 'firebase'
dialog = require '../assets/dialogue'
parser = require './parser'

dataRef = new Firebase("https://vera.firebaseIO.com/")

schedule = require("node-schedule")
rule = new schedule.RecurrenceRule()
rule.second = 0

twilioNumber = "+15186335464"

module.exports =
  checkUp: ()->

    updateFriends = () ->
      dataRef.once "value", (snapshot) ->
        for phoneNumber, dataSet of snapshot.val()
          console.log "===" + phoneNumber + "==="
          for dataKey, dataPack of dataSet
            console.log "---" + dataKey + "---"
            if typeof dataPack is 'object'
              for measurementKey, measurementData of dataPack
                console.log measurementData.height
                console.log measurementData.time
            else
              console.log dataPack

    sendMessage = (phoneNumber, messageBody) -> 
      accountSid = "AC49a0f05f5017e622beda1144f99559f0"
      authToken = "9891f1ca7a89539e1f62966bcf7bc8e9"
      client = require("twilio")(accountSid, authToken)
      client.messages.create
        body: messageBody
        to: phoneNumber
        from: twilioNumber
      , (err, message) ->
        console.log err, message

    job = schedule.scheduleJob rule, () ->
      console.log "Checking on our friends..."
      updateFriends()
    