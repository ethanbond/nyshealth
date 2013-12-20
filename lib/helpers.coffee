request = require 'request'
messenger = require './messenger'

bmi_pool = (bmi) ->
  if bmi < 18
    0
  else if bmi < 25
    1
  else if bmi < 30
    2
  else if bmi < 35
    3
  else
    4

age_pool = (age) ->
  if age < 18
    0
  else if age < 45
    1
  else 2  if age < 65

gender_pool = (gender) ->
  if gender[0] is "m"
    0
  else if gender[0] is "f"
    1
  else
    1


module.exports =
  riskf: (age, bmi, gender) ->
    console.log "BMI " + bmi
    console.log "age " + age
    console.log "gender " + gender
    thedata = [[[7.6, 19.8, 29.7, 57.0, 70.3], [12.2, 17.1, 35.4, 54.6, 74.4]], [[6.9, 17.7, 26.2, 50.9, 62.7], [10.6, 14.7, 30.4, 45.8, 62.2]], [[2.2, 10.8, 14.5, 29.6, 34.7], [3.7, 9.3, 18.0, 27.3, 36.0]]]
    thedata[age_pool(age)][gender_pool(gender)][bmi_pool(bmi)]

  #risk factor from http://care.diabetesjournals.org/content/30/6/1562.full.pdf+html
  #they only have white, black and hispanic for demographic data
  
  text_interval: (riskfactor, isdiabetic) ->
    if isdiabetic
      1
    else
      interval = [7, 6, 5, 4, 3, 2, 1, 1, 1]
      interval[Math.round(riskfactor / 10)]

  #text daily if diabetic, scaled frequency if not

  random_tip: (cb, phoneNumber, type) ->
    req = "https://health.data.ny.gov/resource/diabetes-type-2-prevention-tips.json?category="
    switch
      when type is 'food' then (req = req + "Make%20healthy%20food%20choices")
      when type is 'activity' then (req = req + "Be%20physically%20active")
    request req, (error, response, body) ->
      if error or response.statusCode is not 200
        console.log 'error'
      tip = (JSON.parse(body)[Math.floor(Math.random() * JSON.parse(body).length)]).tip
      while tip.length > 144
        tip = (JSON.parse(body)[Math.floor(Math.random() * JSON.parse(body).length)]).tip
      cb phoneNumber, tip
