
Template.hello.greeting = -> "Welcome to mongosheet."

Template.hello.events
  'click input' : ->
    if (typeof console != 'undefined')
      console.log("You pressed the button")

Meteor.startup ->
    data = [
        ["", "Maserati", "Mazda", "Mercedes", "Mini", "Mitsubishi"],
        ["2009", 0, 2941, 4303, 354, 5814],
        ["2010", 5, 2905, 2867, 412, 5284],
        ["2011", 4, 2517, 4822, 552, 6127],
        ["2012", 2, 2422, 5399, 776, 4151]
    ]
    $('#example').handsontable
        data: data,
        minSpareRows: 1,
        colHeaders: true,
        contextMenu: true