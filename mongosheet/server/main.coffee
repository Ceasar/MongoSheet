Meteor.startup ->
  google_oauth()

google_oauth = ->
  Accounts.loginServiceConfiguration.remove
    service: "google"
  Accounts.loginServiceConfiguration.insert
    service: "google"
    clientId: "735076569928.apps.googleusercontent.com"
    secret: "ZCd0gDJ7-Rjhz3GfKnPJvfYe"

database = {}

Meteor.methods
  # connects to database
  # for each collection, create new Meteor collection and puts in dictionary
  # store dictionary in user's database attribute
  change_database : (db_uri, collection_name) ->
    if not (collection_name of database)
      driver = new MongoInternals.RemoteCollectionDriver db_uri
      collection = new Meteor.Collection collection_name, _driver : driver
      database[collection_name] = collection
      # needs to return true for some reason
      true
  delete_column : (collection_name, column_name) ->
    collection = database[collection_name]
    query = {}
    query[column_name] = {$exists: true}
    none_col = {}
    none_col[column_name] = ''
    collection.update(query, {$unset: none_col}, {multi: true})
