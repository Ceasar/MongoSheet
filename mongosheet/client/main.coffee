
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
    $('#example').handsontable
        data: window.database.collection.find().fetch()
        minSpareRows: 1
        fixedRowsTop: 1
        colHeaders: ['ID', 'Name', 'Address']
        contextMenu: true
        afterChange: (args) ->
          if args?
            row_number = args[0][0]
            table = $('#example').handsontable('getData')
            row = table[row_number]
            window.database[Session.get('current_collection')].update({_id : row._id}, row)
          


Deps.autorun( (c) ->
  populate_table(Session.get('current_collection'))
)

Meteor.startup ->
  populate_collections($('#database').val())
  populate_table(Session.get('current_collection'))
