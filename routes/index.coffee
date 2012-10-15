module.exports = (app) ->
  app.get '/', (req, res) ->
    if req.session.username 
      return res.redirect '/hospital'
    res.render 'index'
  app.all '*', (req, res, next) ->
    #if req.ip is '127.0.0.1' 
    #  return next()
    if req.path.indexOf('/class') == 0 or req.path.indexOf('/hospital') ==0  or req.path.indexOf('/bill') ==0
      if !req.session.username 
        return res.redirect '/' 
    return next()
  app.post '/login', (req, res) ->
    if req.body.password == '123456'
      req.session.username = req.body.username
      return res.redirect '/hospital'
    res.render 'index'
  app.get '/logout', (req, res) ->
    delete req.session.username
    res.render 'index'
