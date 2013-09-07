
window.database = {}

populate_collections = (db_uri) ->
    # calls change_database on server
    Meteor.call("change_database", db_uri, (error, collections) ->
      for collection_name in collections
        if not (collection_name in _.keys(window.database))
          Meteor.subscribe(collection_name)
          window.database[collection_name] = new Meteor.Collection(collection_name)
      Session.set("current_collection", collections[0])
    )

Template.database.events
  'submit form' : (e) ->
    e.preventDefault()
    db_uri = $(e.target).find('[name=database_input]').val()
    populate_collections(db_uri)


populate_table = (collection) ->
  if collection? and window.database[collection]?
    documents = window.database.collection.find().fetch()
    $('#example').handsontable
        data: documents
        minSpareRows: 1
        fixedRowsTop: 1
        colHeaders: get_schema(documents)
        contextMenu: true
        afterChange: (args) ->
          if args?
            row_number = args[0][0]
            table = $('#example').handsontable('getData')
            row = table[row_number]
            window.database[Session.get('current_collection')].update({_id : row._id}, row)
          

# TODO: There assumes that the order of _.keys(schema) returns the columns in
# the same order they're displayed in a row.
get_schema = (documents) ->
  schema = {}
  for document in documents
    schema = _.extend(schema, document)
  return _.keys(schema)

Deps.autorun( (c) ->
  populate_table(Session.get('current_collection'))
)

Meteor.startup ->
  populate_collections($('#database').val())
  populate_table(Session.get('current_collection'))
