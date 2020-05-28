class PersistentAction {
  constructor(options) {
    this.persistentElement = options["persistentElement"]
    this.refershTime = this.persistentElement.data("refresh-time")
  }

  init() {
    this.persistentElement.hide();

    this.persistentElement.parent('form').on('ajax:success', function(event, data, type){
      let notifications_options = {
        displayElement: $("#notifications")
      }
      let notifications = new Notification(notifications_options)
      notifications.init(data.notifications)

    });

    setInterval( () => {
      this.persistentElement.trigger("click")
    },this.refershTime)
  }
}
