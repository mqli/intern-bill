mongoose = require 'mongoose'

module.exports = (mongoose)-> 
  mongoose.model 'Hospital', new mongoose.Schema
    name: String
    price: Number

  mongoose.model 'Class', new mongoose.Schema
    name: String
    amount: Number
    time: Number
    period: Number
    hospitals: [String]
    records: [
      name: String
      amount: Number
      start: Number
      end: Number
    ]
 
  mongoose.model 'Record', new mongoose.Schema
    hospital: String
    class: String
    amount: Number
    time: Number
