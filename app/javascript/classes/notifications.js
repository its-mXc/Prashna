export class Notification {
  constructor(options) {
    this.displayElement = options["displayElement"]
  }
  init(data) {
    this.displayElement.children().remove()
    if(data.length == 0) {
      // FIXME_AB: I18n
      let notification_element = $('<li />').addClass("list-group-item d-flex justify-content-between align-items-center").text("You have no notifications")
      this.displayElement.append(notification_element)
    }
    else {
      data.flatMap((notification) => {
        if(notification.notificable_type == "Question") {
          var notification_element = $('<li />').addClass("list-group-item d-flex justify-content-between align-items-center").html(`<a href='questions/${notification.notificable.url_slug}'>${notification.notificable.user.name} asked a question ${notification.notificable.title}</a>`)
        }
        else {
          if (notification.notificable.commentable_type == "Question") {
            var notification_element = $('<li />').addClass("list-group-item d-flex justify-content-between align-items-center").html(`<a href='comments/${notification.notificable.id}'>${notification.notificable.user.name} replied to your question ${notification.notificable.commentable.title} </a>`)
          }
          else {
            var notification_element = $('<li />').addClass("list-group-item d-flex justify-content-between align-items-center").html(`<a href='comments/${notification.notificable.id}'>${notification.notificable.user.name} replied to your comment ${notification.notificable.commentable.body} </a>`)
          }
        }
        this.displayElement.append(notification_element)
      })
    }
  }
}
