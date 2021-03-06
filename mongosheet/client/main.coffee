window.database = {}

# take the variables from the page to pull collections to the table
create_collections_populate = ->
    db_uri = $('#database').val()
    collection_name = $('#collection').val()
    if not (collection_name of window.database)
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
  collection_name = $('#collection').val()
  collection = window.database[collection_name]
  column_name = prompt("New column name")
  if column_name? and column_name.length > 0
    if collection.find().fetch() == 0
      collection.insert({column_name: ""})
    else
      row = collection.find().fetch()[0]
      row[column_name] = ""
      collection.update({_id : row._id}, row)
      populate_table()

del_column = (e) ->
  column_name = $(e.toElement).siblings()[0].innerText
  collection_name = $('#collection').val()
  Meteor.call('delete_column', collection_name, column_name, ->
    console.log 'column deleted'
    populate_table)

populate_table = ->
  collection_name = $('#collection').val()
  if collection_name? and window.database[collection_name]?
    collection = window.database[collection_name]
    # will throw error if empty collection
    schema = get_schema(collection.find().fetch())
    cols = _.map(schema, (col) ->
      dict = {data: col}
      if col is '_id'
        dict['readOnly'] = true
      return dict
    )
    settings =
        data: get_query()
        colHeaders: schema
        columns: cols
        contextMenu: true
        colWidths: 800 / schema.length
        afterChange: (args) ->
          collection_name = $('#collection').val()
          collection = window.database[collection_name]
          if args?
            row_number = args[0][0]
            table = $('#example').handsontable('getData')
            row = table[row_number]
            # check if there's an id in the row (ie a new row)
            # multiple delete
            if row._id?
              collection.update({_id : row._id}, row)
            else
              delete row._id
              collection.insert(row)
        beforeRemoveRow: (index, amount) ->
          collection_name = $('#collection').val()
          collection = window.database[collection_name]
          table = $('#example').handsontable('getData')
          deleted = table[index..index+amount-1]
          for del in deleted
             collection.remove({_id: del['_id']})
    if $('#example')[0].children.length is 0
      $('#example').handsontable(settings)
    else
      delete settings.afterChange
      delete settings.beforeRemoveRow
      $('#example').handsontable('updateSettings', settings)
    #$('table th:last').append('<button id="new_col">+</button>')
    $('table th').append('<button class="delete_col">-</button>')
    $('#new_col').click(add_column)
    $('.delete_col').click(del_column)

# TODO: There assumes that the order of _.keys(schema) returns the columns in
# the same order they're displayed in a row.
get_schema = (documents) ->
  schema = {}
  for document in documents
    schema = _.extend(schema, document)
  return _.keys(schema)

Meteor.startup ->
  create_collections_populate()
