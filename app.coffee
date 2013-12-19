express 	= require 'express'
app			= require('express')()
server		= require('http').createServer app
io 			= require('socket.io').listen server

routes 		= require './routes'
models		= require './models'

colors		= require 'colors'

app.set 'port', process.env.PORT || 3000
app.set 'views', __dirname + '/views'

app.use express.bodyParser()
app.use express.static(__dirname + '/public')
app.use app.router

if 'development' == app.get 'env' 
	app.use express.errorHandler()


app.get '/twil', routes.twil
app.get '/', routes.index

#TWILIO TESTING

# Your accountSid and authToken from twilio.com/user/account
# accountSid = "AC49a0f05f5017e622beda1144f99559f0"
# authToken = "9891f1ca7a89539e1f62966bcf7bc8e9"
# client = require("twilio")(accountSid, authToken)
# client.sms.messages.create
#   body: "Hi, this is Vera"
#   to: "+13014672873"
#   from: "+15186335464"
# , (err, message) ->
#   process.stdout.write message.sid


server.listen 3000
console.log ('SUCCESS: Express listening on ' + app.get('port')).green
console.log 'INFO:    Good luck!'.cyan