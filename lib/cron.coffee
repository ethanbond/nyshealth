Firebase = require 'firebase'
dialog = require '../assets/dialogue'
parser = require './parser'

dataRef = new Firebase("https://vera.firebaseIO.com/")

schedule = require("node-schedule")
rule = new schedule.RecurrenceRule()
rule.second = 0

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

    job = schedule.scheduleJob rule, () ->
      console.log "Checking on our friends..."
      updateFriends()
    