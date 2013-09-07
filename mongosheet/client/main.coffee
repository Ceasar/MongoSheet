
Template.database.events
  'submit form' : (e) ->
    e.preventDefault()
    # gets database
    db_uri = $(e.target).find('[name=database_input]').val()
    # calls change_database on server
    Meteor.call("change_database", db_uri)

Meteor.startup ->
    data = [
        ["", "Maserati", "Mazda", "Mercedes", "Mini", "Mitsubishi"],
        ["2009", 0, 2941, 4303, 354, 5814],
        ["2010", 5, 2905, 2867, 412, 5284],
        ["2011", 4, 2517, 4822, 552, 6127],
        ["2012", 2, 2422, 5399, 776, 4151]
    ]
    $('#example').handsontable
        data: data
        minSpareRows: 1
        fixedRowsTop: 1
        colHeaders: ['ID', 'Name', 'Address']
        contextMenu: true
        afterChange: -> console.log 'hi'

populate_table = (coll) ->
  $('#example').handsontable
        data: coll.find().fetch()
        minSpareRows: 1
        fixedRowsTop: 1
        colHeaders: false
        contextMenu: true


# TODO afterChange in handsontable to update db
# TODO deps.autorun some shit to feed handsontable new data