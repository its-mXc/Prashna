$(document).on('turbolinks:load', function() {

  let notifications_collapsible_options = {
    clickableElement: $("#notification-bell"),
    collapsibleElement: $("#notifications")
  }

  let collapsibleNotification = new Collapsible(notifications_collapsible_options)
  collapsibleNotification.init()

  let persisistnetNotificationOptions = {
    persistentElement: $(".refresh-notifications")
  }

  let persisistnetNotification = new PersistentAction(persisistnetNotificationOptions)
  persisistnetNotification.init()

})
