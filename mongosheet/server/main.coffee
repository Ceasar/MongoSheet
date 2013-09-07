Meteor.startup ->
  google_oauth()

google_oauth = ->
  Accounts.loginServiceConfiguration.remove
    service: "google"
  Accounts.loginServiceConfiguration.insert
    service: "google"
    clientId: "735076569928.apps.googleusercontent.com"
    secret: "ZCd0gDJ7-Rjhz3GfKnPJvfYe"

names = []

Meteor.methods
  # connects to database
  # for each collection, create new Meteor collection and puts in dictionary
  # store dictionary in user's database attribute
  change_database : (db_uri, collection_name) ->
    if not (collection_name in names)
      driver = new MongoInternals.RemoteCollectionDriver db_uri
      collection = new Meteor.Collection collection_name, _driver : driver
      names.push collection_name