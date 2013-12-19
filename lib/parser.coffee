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

  name = getValue(body, "name:")
  if name
    name = upperCase(name)
    # check & insert phone number into DB
    unless checkIfPhoneExists(phoneNumber)
      console.log phoneNumber
      phoneRef = dataRef.child(phoneNumber)
    # save name
    phoneRef.set
      name: name
      age: null
      gender: null
    return dialog.niceToMeetYou(name)

  gender = getValue(body, "gender:")
  if gender
    gender = upperCase(gender)
    # save gender
    genderRef = dataRef.child(phoneNumber)
    genderRef.update gender: gender
    return dialog.niceToMeetYou(gender)

  age = getValue(body, "age:")
  if age
    # save age
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update age: age
    return dialog.niceToMeetYou(age)

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

  return dialog.whoAreYou()

exports.buildResponse = (fromNumber, messageBody) ->
  resp = new twilio.TwimlResponse()
  resp.sms
    from: twilioNumber
    to: fromNumber
  , messageBody