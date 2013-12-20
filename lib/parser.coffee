twilio = require 'twilio'
Firebase = require 'firebase'
dialogue = require '../assets/dialogue'

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

calculateBMI = (height, weight) ->
  return parseInt((weight/height)*(weight/height)*703)

exports.parse = (body, phoneNumber, cb) ->
  console.log(body)

  # GENERAL STATS
  if getValue(body, "name:")
    console.log "name called"
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
    # save sex
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update sex: sex
    phoneRef.once "value", (snapshot) ->
      if snapshot.val().diabetic is -1
        phoneRef.child('weights').once "value", (snapshot) ->
        for key, val of snapshot.val()
          break
        bmiWeight = val.weight
        phoneRef.child('heights').once "value", (snapshot) ->
        for key, val of snapshot.val()
          break
        bmiHeight = val.height
        cb phoneNumber, dialogue.intro.bmi(calculateBMI(bmiHeight, bmiWeight))
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
    heightRef.push
      height: height
      time: (new Date()).toString()
    phoneRef.child('weight').once "value", (snapshot) ->
      if snapshot.val() is null
        cb phoneNumber, dialogue.intro.weight()
        return
      cb phoneNumber, dialogue.gotIt()
      return

  else if getValue(body, "weight:")
    weight = parseInt(getValue(body, "weight:"))
    # save weight measurement with date
    phoneRef = dataRef.child(phoneNumber)
    weightRef = phoneRef.child('weights')
    weightRef.push
      weight: weight
      time: (new Date()).toString()
    phoneRef.child('weight').once "value", (snapshot) ->
      if snapshot.val() is null
        cb phoneNumber, dialogue.intro.sex()
        return
      cb phoneNumber, dialogue.gotIt()
      return

  else if getValue(body, "diabetic:")
    diabetic = getValue(body, "diabetic:")
    if diabetic == "yes"
      diabetic = true
    else if diabetic == "notsure"
      diabetic = null
    else
      diabetic = false
    # save diabetic
    phoneRef = dataRef.child(phoneNumber)
    phoneRef.update diabetic: diabetic
    cb phoneNumber, dialogue.intro.diabetic(diabetic)
    return

  # DEFAULT

  else if body == "profile"
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

  else if body == "help"
    cb phoneNumber, dialogue.help()
    return

  else if checkIfPhoneExists(phoneNumber)
    cb phoneNumber, dialogue.help()
    return

  else #if checkIfPhoneExists(phoneNumber)
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

