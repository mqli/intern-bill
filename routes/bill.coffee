mongoose = require 'mongoose'
Bill = mongoose.model('Bill')
module.exports = (app) ->
  app.get '/bill', (req, res) ->
    Bill.find (err, bills) -> 
      res.render 'bill' 
        username: req.session.username
        bills: bills

  app.post '/bill/add', (req, res) ->
    Bill.count name: req.body.bill.name, (error, count) ->
      return res.json message: 'duplicate name: ' + req.body.bill.name if  count > 0 
      new Bill(req.body.bill).save (error, bill) -> res.json bill: bill

  app.get '/bill/remove/:billId', (req, res) ->
    Bill.findById req.params.billId, (err, bill) ->
      return  res.json message: 'can not delete' if  bill.students.length > 0 
      bill.remove (err) -> res.json bill: bill

  app.post '/bill/student/add', (req, res) ->
    student = req.body.student;
    Bill.findById req.body.billId, (err, bill) ->
      bill.students.push student
      bill.save (err) -> res.json bill 

  app.get '/bill/:billId/student/remove/:sutdentId', (req, res) ->
    Bill.findById req.params.billId, (err, bill) ->
      bill.students.id(req.params.sutdentId).remove (err, student) ->
        bill.save -> res.json bill