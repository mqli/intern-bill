express = require 'express'
fs = require 'fs'

app = module.exports = express()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser() 
  app.use express.session secret: 'your secret here'
  app.use app.router 
  app.use express.static __dirname + '/public'
  app.use (req, res, next) ->
    if req.ip == '127.0.0.1' or 
      Auth.checkAuth req.path, req.session.username
       return next()
    res.redirect '/'

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

fs.readdirSync(__dirname + '/routes').forEach ->
  if '.js' != name.substr -3 
    require(__dirname + '/routes/' + name)(app)

app.get '/', (req, res) ->
  res.render 'index', title: 'Express'

if !module.parent
  app.listen 3000
  console.log 'Express server listening on port %d', 3000