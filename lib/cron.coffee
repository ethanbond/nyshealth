Firebase = require 'firebase'
# dialog = require '../assets/dialogue'
# parser = require './parser'

schedule = require("node-schedule")
rule = new schedule.RecurrenceRule()
rule.second = 0

module.exports =
  checkUp: ()->
    job = schedule.scheduleJob(rule, ->
      console.log "Checking on our friends..."
    )

