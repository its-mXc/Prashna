export class PersistentAction {
  constructor(options) {
    this.persistentElement = options["persistentElement"]
    this.refershTime = this.persistentElement.data("refresh-time")
  }

  init() {
    this.persistentElement.hide();
    this.persistentElement.parent('form').on('ajax:success', function(r, s, x){
      console.log(r)
      console.log(s)
      console.log(x)
    });
    // FIXME_AB: only for logged in users
    setInterval( () => {
      this.persistentElement.trigger("click")
    },this.refershTime)
  }
}
