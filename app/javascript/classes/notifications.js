export class Notification {
  constructor(options) {
    this.displayElement = options["displayElement"]
  }
  init(data) {
    this.displayElement.children().remove()
    if(data.length == 0) {
      // FIXME_AB: $('<li>', {class: ""}).text()
      // FIXME_AB: I18n
      let notification_element = $('<li class="list-group-item d-flex justify-content-between align-items-center">You have no notifications</li>')
      this.displayElement.append(notification_element)
    }
    else {
      data.flatMap((notification) => {
        let notification_element = $(`<li class="list-group-item d-flex justify-content-between align-items-center">${notification.question.user.name} asked a question <a href='${notification.question.url_slug}'>${notification.question.title}</a></li>`)
        this.displayElement.append(notification_element)
      })
    }
  }
}
