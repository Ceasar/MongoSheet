Meteor.startup ->
  google_oauth()

google_oauth = ->
  Accounts.loginServiceConfiguration.remove
    service: "google"
  Accounts.loginServiceConfiguration.insert
    service: "google"
    clientId: "735076569928.apps.googleusercontent.com"
    secret: "ZCd0gDJ7-Rjhz3GfKnPJvfYe"

get_coll = (coll_name, db_uri) ->
  driver = new MongoInternals.RemoteCollectionDriver db_uri
  coll = new Meteor.Collection coll_name, _driver : driver
  return coll

# broken
list_colls = (db_uri) ->
  ["collection"]
  # MongoDB.connect(db, {db: {safe: true}}, (err, db) ->
  #   db.collectionNames (err, items) ->
  #     console.log(items))

Meteor.methods
  # connects to database
  # for each collection, create new Meteor collection and puts in dictionary
  # store dictionary in user's database attribute  
  change_database : (db_uri) ->
    newDatabase = {}
    newDatabase[coll_name] = get_coll(coll_name, db_uri) for coll_name in list_colls(db_uri)
    console.log newDatabase.collection.find().fetch()
    # TODO set user's new URI
    # TODO set user's new database

