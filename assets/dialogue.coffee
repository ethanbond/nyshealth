module.exports =
	intro = 
		init: () ->
			"Hey I'm Vera, it's nice to meet you. What's your name? For example: 'Robert'"

		age: (name) ->
			"Hi " + name + " I have some questions for you. First, what's your age in years? For example: 'age: 37'"

		height: () ->
			"Great. How tall are you in inches? Don't be shy! For example: 'height: 64'"

		weight: () ->
			"No way, me too! How much do you weigh in pounds? For example: 'weight: 214'"

		sex: () ->
			"I'm going to calculate your BMI, but you have to tell me what sex you are. For example: 'sex: Female' or 'sex: Male'"

		bmi: (bmi) ->
			str = "It looks like you have a BMI of " + bmi + ", which is "
			if bmi < 18.5 then str += "underweight. We'll get you back on track!"
			if bmi < 25 and bmi >= 18.5 then str += "healthy. Let's keep it that way!"
			if bmi < 30 and bmi >= 25 then str += "overweight. We'll get you back on track!"
			if bmi > 30 then str += "obese. Get ready to turn your life around :)"
			str += " Are you diabetic? For example: 'diabetic: yes', 'diabetic: no', or 'diabetic: not sure'"
			return str
		
		diabetic: (isDiabetic) ->
			if isDiabetic is null then return "If you suspect something's wrong, it's always a good idea to ask a doctor. But I'll help you make better choices, with or without diabetes!"
			if isDiabetic then return "Ah, don't worry too much! You can fight diabetes with good choices, and that's why I'm here."
			if not isDiabetic then return "Good for you! Keeping diabetes away is important, and surprisingly simple as long as you make good decisions."

		goodbye: (name, age, height, weight, sex, diabetic) ->
			return "Alright, " + name + "! I have you down as " + age + " years old, " + sex + ", " + parseHeight(height) + " tall, " + weight + " pounds. Did I mess anything up? You can tell me about your health at any time. Here are the things I care about:
					height, weight, age, foods, minutes of activity, fasting glucose, resting heart rate, and calories. Tell me 'help' if you forget about these!"









printFoods: (list) ->
	last = list[list.length - 1]
	str = ''
	for item in list
		if item is not last
			str += item + ', '

	return str

getData: (phone) ->


help: () ->
	return """
	Don't worry, I'm here already! Here's a list of example things you can tell me:
	'get data',	
	'name: Ray',
	'height: 60',
	'weight: 214',
	'food: salad, steak, potatos',
	'calories: 1850',
	'age: 20',
	'minutes of activity: 45',
	'fasting glucose: 82',
	'resting heart rate: 63'
	"""

switchType: (baseStr, type) ->
	switch
		when type is 1 then return baseStr + "What did you eat today? Respond with: 'I ate _____, _____, _____'"
		when type is 2 then return baseStr + "Has your weight changed recently? Respond with: 'I weigh ___ pounds.'"
		when type is 3 then return baseStr + "Roughly how many calories did you eat today? Respond with: 'I ate ___ calories."
		when type is 4 then return baseStr + "Did you eat any vegetables today? Respond with: 'I ate ___ servings of vegetables.'"

dataReq: (name, time, requestType) ->
	if time < 12:
		return switchType("Good morning " + name + "! Just thought I'd drop in and make sure you're still on track. ", requestType)
	return switchType("Good evening " + name + "! Just thought I'd drop in and make sure you're still on track. ", requestType)

response: (q, a, recL, recH) ->
	if a > recL and a < recH 		# this is good!
		switch
			when q is 1 then return "Wow! Those all seem pretty healthy! Keep up the good work."
			when q is 2 then return "Looking good :) You're probably feeling better, too. Good choices pay off!"
			when q is 3 then return "Nice, that's within the healthy range - good work."
			when q is 4 then return "See, they're not that bad! Keep going :)"
	else
		switch
			when q is 1 then return "Uh oh... The " + printFoods a + " is probably less healthy than you think. I'll check in tomorrow to see if you made better choices!"
			when q is 2 then return a + " pounds? You've got some work to do! Try walking a bit more to make up for the caloric intake. I'll come by again tomorrow to see some progress!"
			when q is 3 then return "Eek :( " + a + " calories is more than enough for you! Try to watch how much you're eating tomorrow and I'll check back in."
			when q is 4 then return "Vegetables really aren't that bad. Really! Eat some more tomorrow and I'll stop by to see some progress"
