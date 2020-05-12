class PersistentAction {
  constructor(options) {
    this.persistentElement = options["persistentElement"]
    this.refershTime = this.persistentElement.data("refresh-time")
  }

  init() {
    this.persistentElement.hide()
    setInterval( () => {
      this.persistentElement.trigger("click")
    },this.refershTime)
  }
}