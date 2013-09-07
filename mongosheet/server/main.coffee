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

create_collection = (collection_name, db_uri) ->
  console.log names
  if not (collection_name in names)
    driver = new MongoInternals.RemoteCollectionDriver db_uri
    collection = new Meteor.Collection collection_name, _driver : driver
    names.push collection_name
    # relying on autopublish

# broken
list_collections = (db_uri) ->
  ["collection"]
  # MongoDB.connect(db, {db: {safe: true}}, (err, db) ->
  #   db.collectionNames (err, items) ->
  #     console.log(items))

Meteor.methods
  # connects to database
  # for each collection, create new Meteor collection and puts in dictionary
  # store dictionary in user's database attribute  
  change_database : (db_uri) ->
    collections = list_collections(db_uri)
    for collection_name in collections
      create_collection(collection_name, db_uri)
    return collections
     
     # newDatabase.collection
    # TODO set user's new URI
    # TODO set user's new database

