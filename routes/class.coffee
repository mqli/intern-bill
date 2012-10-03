mongoose = require 'mongoose'
Class = mongoose.model('Class')
Hospital = mongoose.model('Hospital')

module.exports = (app) ->
  app.get '/class', (req, res) ->
    Class.find (err, classes)->
      Hospital.find (err, hospitals) ->
        res.render 'class',
          classes: classes
          hospitals:hospitals

  app.post '/class/new', (req, res) ->
    Class.count name: req.body.class.name, (err, count)->
      if count > 0
        return res.json error: 'duplicate class name'
      clazz = req.body.class
      new Class(clazz).save (err, clazz) ->
        res.json class: clazz;

  app.get '/class/remove/:id', (req, res) ->
    Record.find clazz: req.params.id, (err, count)->
      if count > 0
        return res.json error: 'has intern record can\'t delete'
      Class.findById req.params.id, (err, clazz) ->
        clazz.remove ->
          res.json class: clazz