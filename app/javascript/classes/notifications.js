export class Notification {
  constructor(options) {
    this.displayElement = options["displayElement"]
  }
  init(data) {
    this.displayElement.children().remove()
    if(data.length == 0) {
      // FIXME_AB: $('<li>', {class: ""}).text()
      // FIXME_AB: I18n
      let notification_element = $('<li />').addClass("list-group-item d-flex justify-content-between align-items-center").text("You have no notifications")
      this.displayElement.append(notification_element)
    }
    else {
      data.flatMap((notification) => {
        let notification_element = $('<li />').addClass("list-group-item d-flex justify-content-between align-items-center").text(`${notification.question.user.name} asked a question <a href='${notification.question.url_slug}'>${notification.question.title}</a>`)
        this.displayElement.append(notification_element)
      })
    }
  }
}
