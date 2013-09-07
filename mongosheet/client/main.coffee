window.database = {}

# take the variables from the page to pull collections to the table
create_collections_populate = ->
    db_uri = $('#database').val()
    collection_name = $('#collection').val()
    if not (collection_name in _.keys(window.database))
      # calls change_database on server
      Meteor.call("change_database", db_uri, collection_name, (error) ->
        Meteor.subscribe(collection_name)
        window.database[collection_name] = new Meteor.Collection(collection_name)
        Deps.autorun ->
          if window.database[collection_name].find().fetch().length > 0
            populate_table()
      )
    else
      populate_table()


Template.query.events
  'submit form' : (e) ->
     e.preventDefault()
     create_collections_populate()

get_query = () ->
  s = "window.database.#{$('#collection').val()}.find({ #{$('#query').val()} }).fetch()"
  return eval(s)

add_column = ->
  column_name = prompt("New column name")
  if column_name?
    console.log column_name

populate_table = ->
  collection_name = $('#collection').val()
  if collection_name? and window.database[collection_name]?
    collection = window.database[collection_name]
    # will throw error if empty collection
    schema = get_schema(collection.find().fetch())
    schema.push('')
    cols = _.map(schema, (col) ->
      dict = {data: col}
      if col is '_id'
        dict['readOnly'] = true
      return dict
    )
    $('#example').handsontable
        data: get_query()
        minSpareRows: 1
        minSpareCols: 1
        colHeaders: schema
        columns: cols
        contextMenu: true
        colWidths: 800 / schema.length
        afterChange: (args) ->
          if args?
            row_number = args[0][0]
            table = $('#example').handsontable('getData')
            row = table[row_number]
            collection.update({_id : row._id}, row)
        beforeRemoveRow: (index, amount) ->
          table = $('#example').handsontable('getData')
          deleted = table[index..index+amount-1]
          for del in deleted
             collection.remove({_id: del['_id']})
    $('table th:last').html('<button id="new_col">+</button>')
    $('#new_col').click( -> add_column())

# TODO: There assumes that the order of _.keys(schema) returns the columns in
# the same order they're displayed in a row.
get_schema = (documents) ->
  schema = {}
  for document in documents
    schema = _.extend(schema, document)
  return _.keys(schema)

Meteor.startup ->
  create_collections_populate()
