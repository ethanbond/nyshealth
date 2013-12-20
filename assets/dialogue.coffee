module.exports =
	intro:
		init: () ->
			"Hey I'm Vera, it's nice to meet you. What's your name? For example: 'name: Robert'"

		age: (name) ->
			return "Hi " + name + " I have some questions for you. First, what's your age in years? For example: 'age: 37'"

		height: () ->
			"Great. How tall are you in inches? Don't be shy! For example: 'height: 64'"

		weight: () ->
			"No way, me too! How much do you weigh in pounds? For example: 'weight: 214'"

		sex: () ->
			"I'm going to calculate your BMI, but you have to tell me what sex you are. For example: 'sex: Female' or 'sex: Male'"

		bmi: (bmi) ->
			str = "You have a BMI of " + bmi + ", which is "
			if bmi < 18.5
				str += "underweight. We'll get you on track!"
			if (bmi < 25 and bmi >= 18.5)
				str += "healthy. Good work!"
			if (bmi < 30 and bmi >= 25)
				str += "overweight. We'll get you on track!"
			if bmi > 30
				str += "obese. Let's fix that!"
			str += " Are you diabetic? 'diabetic: yes/no/not sure'"
			return str
		
		diabetic: (isDiabetic) ->
			if isDiabetic is null then return "If you think something's wrong, it's always a good to ask a doctor. But I'll info you make better choices, w/ or w/o diabetes! Try 'info' to see what I can do"
			if isDiabetic then return "Don't worry too much! You can fight diabetes with good choices, and that's why I'm here. Type 'info' to see what I can do"
			if not isDiabetic then return "Great! Keeping diabetes away is important, and surprisingly simple as long as you make good decisions. Type 'info' to see what I can do"




	profile: (name, age, sex, diabetic) ->
		return name + ", are you a " + age + " year old " + sex + "? You can update weight, activity, glucose, heart rate & more any time. Say 'info' if you forget!"

	printFoods: (list) ->
		last = list[list.length - 1]
		str = ''
		for item in list
			if item is not last
				str += item + ', '

		return str

	# getData: (phone) ->


	info: () ->
		return """
		'data',
		'profile',	
		'name: Ray',
		'height: 60',
		'weight: 214',
		'food: soup, steak',
		'calories: 900',
		'age: 20',
		'activity: 45',
		'glucose: 82',
		'heart rate: 63'
		"""

	gotIt: () ->
		return "Got it!"

	reminder: () ->
		return "Hey there! Just checking in -- how are you? How about taking another measurement. You can say info anytime you need help."

	switchType: (baseStr, type) ->
		switch
			when type is 1 then return baseStr + "What did you eat today? Respond with: 'I ate _____, _____, _____'"
			when type is 2 then return baseStr + "Has your weight changed recently? Respond with: 'I weigh ___ pounds.'"
			when type is 3 then return baseStr + "Roughly how many calories did you eat today? Respond with: 'I ate ___ calories."
			when type is 4 then return baseStr + "Did you eat any vegetables today? Respond with: 'I ate ___ servings of vegetables.'"

	dataReq: (name, time, requestType) ->
		if time < 12
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
