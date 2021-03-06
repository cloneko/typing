###*
# Module dependencies.
###


express = require 'express'
routes = require './routes'
fs = require 'fs'
app = module.exports = express.createServer()
io = require('socket.io')(app)
uuid = require('uuid')

# Configuration
app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')
  return
app.configure 'development', ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true)
  return
app.configure 'production', ->
  app.use express.errorHandler()
  return
# Routes
app.get '/', routes.index
app.get '/index2', routes.index2
app.listen 3000, ->
  console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env
  return



# socket.io

getKeyword = -> 
  dict = ['http://www.google.com/','jQuery','ぬるぽ','System.out.println()','I love Python!!!!!!!','socket.io + express + jade','お前はもう死んでいる…','CoffeeScript','東京特許許可局','ハローワールド','花崗岩','Haローわールど','みんな授業受けましょう!','rm -fr /','罵詈雑言','asdf1234','すももももももももものうち']
  dict[Math.floor(Math.random() * dict.length)]

keyword = getKeyword()
members = 0

io.on 'connection', (socket) ->
  socket.emit 'login', {uuid:uuid.v4(), current:keyword}
  members += 1
  io.sockets.emit 'updateMembers', members

  socket.on 'send', (data) ->
    console.log data 
    if data['answer'] is keyword
      before = keyword
      keyword = getKeyword()
      io.sockets.emit 'notify', {before: before, current: keyword, uuid: data['uuid']}

  socket.on 'current', (data) ->
    socket.broadcast.emit 'enemy', data

  socket.on 'disconnect', (data) ->
    members -= 1
    io.sockets.emit 'updateMembers', members
