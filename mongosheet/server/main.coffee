
Meteor.startup ->
  Accounts.loginServiceConfiguration.remove
    service: "google"
  Accounts.loginServiceConfiguration.insert
    service: "google"
    clientId: "735076569928.apps.googleusercontent.com"
    secret: "ZCd0gDJ7-Rjhz3GfKnPJvfYe"