introduction: () ->
	"Hey there, I'm Vera. I'll help you keep your health on track, but first, what's your name?
	Respond with: 'My name is ______'"


printFoods: (list) ->
	last = list[list.length - 1]
	str = ''
	for item in list
		if item is not last
			str += item + ', '

	return str


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
