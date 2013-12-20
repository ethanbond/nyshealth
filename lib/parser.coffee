twilio = require 'twilio'
Firebase = require 'firebase'
dialogue = require '../assets/dialogue'

helpers = require './helpers'

twilioNumber = "+15186335464"
dataRef = new Firebase("https://vera.firebaseIO.com/")

upperCase = (word) ->
  (word.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '

getValue = (body, trigger) ->
  lower = body.toLowerCase()
  noWS = lower.replace RegExp(" ","g"), ""
  split = noWS.split trigger
  return split[1]

checkIfPhoneExists = (phoneNumber, callback) ->
  dataRef.child(phoneNumber).once "value", (snapshot) ->
    exists = (snapshot.val() is null)
    callback (not exists)

calculateBMI = (weight, height) ->
  height = parseInt height
  weight = parseInt weight
  denominator = height * height
  numerator = weight
  frac = numerator / denominator
  return frac * 703

getInterval = (age, bmi, gender, isDiabetic) ->
  helpers.text_interval helpers.riskf(age, bmi, gender), isDiabetic
# helper functions also expose random_food_tip(cb(JSONtip))

exports.parse = (body, phoneNumber, cb) ->
  console.log(body)

  # GENERAL STATS
  if getValue(body, "name:")
    name = getValue(body, "name:")
    name = upperCase(name)
    # save name
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update name: name
    phoneRef.once "value", (snapshot) ->
      if snapshot.val().age is -1
        cb phoneNumber, dialogue.intro.age(name)
        return
      cb phoneNumber, dialogue.gotIt()
      return

  else if getValue(body, "sex:")
    sex = getValue(body, "sex:")
    sex = upperCase(sex)
    # save sex, cherish it.
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update sex: sex
    phoneRef.once "value", (snapshot) ->
      if snapshot.val().diabetic is -1
        bmiWeight = 150
        bmiHeight = 70
        phoneRef.child('weights').once "value", (snapshot) ->
          for key, val of snapshot.val()
            phoneRef.child('heights').once "value", (ss) ->
              for k, v of ss.val()
                cb phoneNumber, dialogue.intro.bmi(calculateBMI val.weight, v.height)
                break
            break
        return
      cb phoneNumber, dialogue.gotIt()
      return

  else if getValue(body, "age:")
    age = parseInt(getValue(body, "age:"))
    # save age
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update age: age
    phoneRef.child('heights').once "value", (snapshot) ->
      if snapshot.val() is null
        cb phoneNumber, dialogue.intro.height()
        return
      cb phoneNumber, dialogue.gotIt()
      return

  # RECURRING MEASUREMENTS
  else if getValue(body, "height:")
    height = parseInt(getValue(body, "height:"))
    # save height measurement with date
    phoneRef = dataRef.child(phoneNumber)
    heightRef = phoneRef.child('heights')
    heightRef.once "value", (snapshot) ->
      if snapshot.val() is null
        cb phoneNumber, dialogue.intro.weight()
        heightRef.push
          height: height
          time: (new Date()).toString()
        return
      cb phoneNumber, dialogue.gotIt()
      heightRef.push
        height: height
        time: (new Date()).toString()
      return

  else if getValue(body, "weight:")
    weight = parseInt(getValue(body, "weight:"))
    # save weight measurement with date
    phoneRef = dataRef.child(phoneNumber)
    weightRef = phoneRef.child('weights')
    weightRef.once "value", (snapshot) ->
      if snapshot.val() is null
        cb phoneNumber, dialogue.intro.sex()
        weightRef.push
          weight: weight
          time: (new Date()).toString()
        return
      cb phoneNumber, dialogue.gotIt()
      weightRef.push
        weight: weight
        time: (new Date()).toString()
      return

  else if getValue(body, "diabetic:")
    diabetic = getValue(body, "diabetic:")
    if diabetic is "yes"
      diabetic = true
    else if diabetic is "notsure"
      diabetic = null
    else
      diabetic = false
    # save diabetic
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update diabetic: diabetic
    cb phoneNumber, dialogue.intro.diabetic(diabetic)
    return

  # DEFAULT

  else if body.toLowerCase() is "profile"
    phoneRef.once "value", (snapshot) ->
      name = snapshot.val().name
      age = snapshot.val().age
      sex = snapshot.val().sex
      dbe = snapshot.val().diabetic
      diabetic = "not sure"
      if dbe
        diabetic = "yes"
      else
        diabetic = "no"
    cb phoneNumber, dialogue.profile(name, age, sex, diabetic)
    return

  else if body.toLowerCase() is "info"
    cb phoneNumber, dialogue.info()
    return

  else
    checkIfPhoneExists phoneNumber, (exists) ->
      if not exists
        console.log phoneNumber
        phoneRef = dataRef.child(phoneNumber)
        # save default data
        phoneRef.set
          name: -1
          age: -1
          sex: -1
          diabetic: -1
        cb phoneNumber, dialogue.intro.init()
        return
      cb phoneNumber, dialogue.info()
      return

