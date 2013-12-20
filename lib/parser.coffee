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

makeUrlString = () ->
  text = ""
  possible = "abcdefghijklmnopqrstuvwxyz0123456789"
  i = 0

  while i < 6
    text += possible.charAt(Math.floor(Math.random() * possible.length))
    i++
  text

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


updateInterval = (phoneNumber, newInterval) ->
  phoneRef = dataRef.child(phoneNumber)
  phoneRef.child('daysUntil').once "value", (snapshot) ->
    console.log snapshot.val()
    console.log newInterval
    if newInterval < snapshot.val() || snapshot.val() < 1
      phoneRef.update daysUntil: newInterval

updateTimeSeries = (phoneNumber) ->
  phoneRef = dataRef.child(phoneNumber)
  phoneRef.child('age').once "value", (age_ss) ->
    age = age_ss.val()
    phoneRef.child('sex').once "value", (sex_ss) ->
      sex = sex_ss.val()
      phoneRef.child('diabetic').once "value", (diabetic_ss) ->
        isDiabetic = (diabetic_ss.val() or false)
        phoneRef.child('weights').once "value", (weights_ss) ->
          weightResult = []
          for key, val of weights_ss.val()
            for w1, w2 of val
              if w1 is 'weight'
                weightResult.push w2
          latestWeight = weightResult[weightResult.length - 1]
          phoneRef.child('heights').once "value", (heights_ss) ->
            heightResult = []
            for k, v of heights_ss.val()
              for h1, h2 of v
                if h1 is 'height'
                  heightResult.push h2
            latestHeight = heightResult[heightResult.length - 1]
            updateInterval phoneNumber, (getInterval age, (calculateBMI latestWeight, latestHeight), sex, isDiabetic)

exports.updateTimeSeries = (phoneNumber) ->
  phoneRef = dataRef.child(phoneNumber)
  phoneRef.child('age').once "value", (age_ss) ->
    age = age_ss.val()
    phoneRef.child('sex').once "value", (sex_ss) ->
      sex = sex_ss.val()
      phoneRef.child('diabetic').once "value", (diabetic_ss) ->
        isDiabetic = (diabetic_ss.val() or false)
        phoneRef.child('weights').once "value", (weights_ss) ->
          weightResult = []
          for key, val of weights_ss.val()
            for w1, w2 of val
              if w1 is 'weight'
                weightResult.push w2
          latestWeight = weightResult[weightResult.length - 1]
          phoneRef.child('heights').once "value", (heights_ss) ->
            heightResult = []
            for k, v of heights_ss.val()
              for h1, h2 of v
                if h1 is 'height'
                  heightResult.push h2
            latestHeight = heightResult[heightResult.length - 1]
            updateInterval phoneNumber, (getInterval age, (calculateBMI latestWeight, latestHeight), sex, isDiabetic)


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
        phoneRef.child('weights').once "value", (snapshot) ->
          for key, val of snapshot.val()
            phoneRef.child('heights').once "value", (ss) ->
              for k, v of ss.val()
                phoneRef.update daysUntil: 1
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
          time: new Date() / 1000
        return
      cb phoneNumber, dialogue.gotIt()
      heightRef.push
        height: height
        time: new Date() / 1000
      updateTimeSeries phoneNumber
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
          time: new Date() / 1000
        return
      cb phoneNumber, dialogue.gotIt()
      weightRef.push
        weight: weight
        time: new Date() / 1000
      updateTimeSeries phoneNumber
      return

  else if getValue(body, "diabetic:")
    diabetic = getValue(body, "diabetic:")
    if diabetic.toLowerCase() is "yes"
      diabetic = true
    else if diabetic.toLowerCase() is "notsure"
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

  else if body.toLowerCase() is "export"
    urlString = makeUrlString()
    phoneRef.update exportURL: urlString
    cb phoneNumber, "visit /" + urlString
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

