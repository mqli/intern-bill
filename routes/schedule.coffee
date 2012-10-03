mongoose = require 'mongoose'
Class = mongoose.model('Class')

module.exports = (app) ->
  app.get '/class/:id/schedule', (req, res) ->
    Class.findById req.params.id, (err, clazz) ->
      clazz = clazz.toObject()
      clazz.groupedRecords = {};
      clazz.hospitals.forEach (hospital) ->
        clazz.groupedRecords[hospital] = []
      clazz.records.forEach (record) ->
        clazz.groupedRecords[record.name].push(record)
      res.render 'schedule', clazz: clazz

  app.post '/class/:id/schedule/new', (req, res) ->
    Class.findById req.params.id, (err, clazz) ->
      clazz.records.push(req.body.record)
      clazz.save (err, clazz) ->
        res.redirect '/class/' + clazz._id + '/schedule'

  app.get '/class/:id/schedule/remove/:recordId', (req, res) ->
    Class.findById req.params.id, (err, clazz) ->
      clazz.records.id(req.params.recordId).remove()
      clazz.save (err, clazz) ->
        res.redirect '/class/' + clazz._id + '/schedule'