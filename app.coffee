express = require 'express'
mongoose = require 'mongoose'

fs = require 'fs'
config = require './config.coffee'

app = module.exports = express()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.logger 'dev' 
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser() 
  app.use express.session secret: 'your secret here'
  app.use app.router 
  app.use express.static __dirname + '/public'
  app.use (req, res, next) ->
    if req.session.username or req.path.indexOf('/bill') < 0 or
      req.ip is '127.0.0.1'
        return next()
    res.redirect '/'

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

require('./models/models.coffee')(mongoose);

fs.readdirSync(__dirname + '/routes').forEach (name)->
  if '.coffee' == name.substr -7 
    console.log 'routes file:' +  name
    require(__dirname + '/routes/' + name)(app)

mongoose.connect(config.MONGO_HOST, config.MONGO_DB, config.MONGO_PORT);
console.log 'mongo connect on port %d',  config.MONGO_PORT
app.listen config.SERVER_PORT
console.log 'Express server listening on port %d', config.SERVER_PORT