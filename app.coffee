express 	= require 'express'
app			= require('express')()
server		= require('http').createServer app
io 			= require('socket.io').listen server

routes 		= require './routes'
models		= require './models'

colors		= require 'colors'
dust		= require 'dustjs-linkedin'
cons 		= require 'consolidate'
sass		= require 'node-sass'

app.set 'port', process.env.PORT || 3000
app.set 'views', __dirname + '/views'

app.use express.bodyParser()
app.use express.static(__dirname + '/public')
app.use app.router

if 'development' == app.get 'env' 
	app.use express.errorHandler()


app.get '/', routes.index

server.listen 3000
console.log ('SUCCESS: Express listening on ' + app.get('port')).green
console.log 'INFO:    Good luck!'.cyan