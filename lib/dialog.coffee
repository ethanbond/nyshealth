module.exports =
  defaultContent: ()->
    "Default content - I should never show up"
  whoAreYou: ()->
    "Hi, I'm Vera, your best friend. Who are you? Respond with: My name is _____"
  niceToMeetYou: (name)->
    "Nice to meet you " + name + " . Tell me, how much do you weigh?"



# module.exports =
#   index: (req, res)->
#     res.send 'Nothing ot see here'
#   twil: (req, res)->
#     console.log 'Incoming request data: '
#     for k, v of req.query
#       console.log k.green+v
#     content = parser.parse(req.query.Body)
#     resp = parser.buildResponse(req.query.From, content)
#     res.writeHead 200,
#       "Content-Type": "text/xml"
#     res.end resp.toString()
