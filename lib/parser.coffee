twilio = require 'twilio'
Firebase = require 'firebase'
dialog = require './dialog'

twilioNumber = "+15186335464"
dataRef = new Firebase("https://vera.firebaseIO.com/")

upperCase = (word) ->
  (word.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '

getValue = (body, trigger) ->
  lower = body.toLowerCase()
  noWS = lower.replace RegExp(" ","g"), ""
  split = noWS.split trigger
  return split[1]

checkIfPhoneExists = (phoneNumber) ->
  dataRef.child(phoneNumber).once "value", (snapshot) ->
    exists = (snapshot.val() isnt null)
    return exists

exports.parse = (body, phoneNumber) ->
  console.log(body)

  # GENERAL STATS
  name = getValue(body, "name:")
  if name
    name = upperCase(name)
    # save name
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update name: name
    return dialog.niceToMeetYou(name)

  gender = getValue(body, "gender:")
  if gender
    gender = upperCase(gender)
    # save gender
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update gender: gender
    return dialog.niceToMeetYou(gender)

  age = getValue(body, "age:")
  if age
    # save age
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update age: age
    return dialog.niceToMeetYou(age)

  # RECURRING MEASUREMENTS
  weight = getValue(body, "weight:")
  if weight
    # save weight measurement with date
    weightRef = dataRef.child(phoneNumber).child('weights')
    weightRef.push
      weight: weight
      time: (new Date()).toString()
    return dialog.thanks()

  height = getValue(body, "height:")
  if height
    # save height measurement with date
    heightRef = dataRef.child(phoneNumber).child('heights')
    heightRef.push
      height: height
      time: (new Date()).toString()
    return dialog.thanks()

  diabetic = getValue(body, "diabetic:")
  if diabetic
    # save diabetic
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update diabetic: diabetic
    return dialog.diabetic

  # DEFAULT

  if body == "help"
    return dialog.help()

  unless checkIfPhoneExists(phoneNumber)
    console.log phoneNumber
    phoneRef = dataRef.child(phoneNumber)
  # save default data
  phoneRef.set
    name: null
    age: null
    gender: null
    diabetic: null
  return dialog.whoAreYou()

exports.buildResponse = (fromNumber, messageBody) ->
  resp = new twilio.TwimlResponse()
  resp.sms
    from: twilioNumber
    to: fromNumber
  , messageBody