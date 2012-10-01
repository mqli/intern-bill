mongoose = require 'mongoose'
Class = mongoose.model('Class')
Record = mongoose.model('Record')

module.exports = (app) ->
  app.get '/class', (req, res) ->
    Class.find (err, classes)->
      res.render 'class', classes: classes

  app.post '/class/new', (req, res) ->
    Class.count name: req.body.class.name, (err, count)->
      if count > 0
        return res.json error: 'duplicate class name'
      new Class(req.body.class).save (err, clazz) ->
        res.json class: clazz;

  app.get '/class/remove/:id', (req, res) ->
    Record.find clazz: req.params.id, (err, count)->
      if count > 0
        return res.json error: 'has intern record can\'t delete'
      Class.findById req.params.id, (err, clazz) ->
        clazz.remove ->
          res.json class: clazz