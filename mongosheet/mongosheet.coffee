
if Meteor.isClient
  Template.hello.greeting = -> "Welcome to mongosheet."

  Template.hello.events
    'click input' : ->
      if (typeof console != 'undefined')
        console.log("You pressed the button")

if Meteor.isServer
  Meteor.startup ->
    null
