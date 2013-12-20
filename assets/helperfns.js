
function bmi_pool(bmi) {
 if (bmi < 18)
	return 0;
 else if (bmi < 25)
	return 1;
 else if (bmi < 30)
	return 2;
 else if (bmi < 35)
	return 3;
 else 
	return 4
}

function age_pool(age) {
 if (age < 18)
	return 0;
 else if (age < 45)
	return 1;
 else if (age < 65)
	return 2;
}

function gender_pool(gender) {
 if (gender[0] == "m")
	return 0;
 else if (gender[0] == "f")
	return 1;
}

function riskf(age, bmi, gender) {

 var thedata = [[[7.6, 19.8, 29.7, 57.0, 70.3],[12.2, 17.1, 35.4, 54.6, 74.4]],
		[[6.9, 17.7, 26.2, 50.9, 62.7],[10.6, 14.7, 30.4, 45.8, 62.2]],
		[[2.2, 10.8, 14.5, 29.6, 34.7],[3.7, 9.3, 18.0, 27.3, 36.0]]];
 return thedata[age_pool(age)][gender_pool(gender)][bmi_pool(bmi)];
  //risk factor from http://care.diabetesjournals.org/content/30/6/1562.full.pdf+html
  //they only have white, black and hispanic for demographic data

}

function text_freq(riskfactor, isdiabetic) {
 if (isdiabetic) {
	return 1;
 }
 else {
 	thefreqs = [7, 6, 5, 4, 3, 2, 1, 1, 1];
	return thefreqs[Math.round(riskfactor/10)];
 }
 //text daily if diabetic, scaled frequency if not
}

function random_food_tip() {
 a = $.getJSON( "https://health.data.ny.gov/resource/diabetes-type-2-prevention-tips.json?category=Make%20healthy%20food%20choices", function( json ) {
	alert( json[Math.floor(Math.random()*json.length)].tip );
	//instead of alert use whatever function pushes a text message
 });
}
