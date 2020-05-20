import {Notification} from'../classes/notifications'
export class PersistentAction {
  constructor(options) {
    this.persistentElement = options["persistentElement"]
    this.refershTime = this.persistentElement.data("refresh-time")
  }

  init() {
    this.persistentElement.hide();

    this.persistentElement.parent('form').on('ajax:success', function(event){
      let notifications_options = {
        displayElement: $("#notifications")
      }
      let notifications = new Notification(notifications_options)
      notifications.init(event.detail[0]["notifications"])

    });

    setInterval( () => {
      this.persistentElement.trigger("click")
    },this.refershTime)
  }
}
