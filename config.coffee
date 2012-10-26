module.exports = 
  SERVER_HOST: process.env.VCAP_APP_HOST || 'localhost'
  SERVER_PORT: 3000
  MONGO_HOST: 'localhost'
  MONGO_PORT: 27017
  MONGO_DB: 'test'