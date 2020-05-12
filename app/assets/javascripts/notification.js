$(document).ready(function() { 

  let notifications_collapsible_options = {
    clickableElement: $("#notification-bell"),
    collapsibleElement: $("notifications")
  }

  let collapsibleNotification = new Collapsible(notifications_collapsible_options)
  collapsibleNotification.init()

  setInterval(function(){
    $(".refresh-notifications").trigger("click")
  },20000)
})