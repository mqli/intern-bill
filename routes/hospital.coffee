mongoose = require 'mongoose'

Hospital = mongoose.model('Hospital')
Record = mongoose.model('Record')

module.exports = (app) ->
  app.get '/hospital', (req, res) ->
    Hospital.find (err, hospitals)->
      res.render 'hospital', hospitals: hospitals

  app.post '/hospital/new', (req, res) ->
    Hospital.count name: req.body.hospital.name, (err, count)->
      if count > 0
        return res.json error: 'duplicate hospital name'
      new Hospital(req.body.hospital).save (err, hospital) ->
        res.json hospital: hospital;

  app.get '/hospital/remove/:id', (req, res) ->
    Record.find hospital: req.params.id, (err, count)->
      if count > 0
        return res.json error: 'has intern record can\'t delete'
      Hospital.findById req.params.id, (err, hospital) ->
        hospital.remove ->
          res.json hospital: hospital;