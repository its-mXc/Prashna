export class Collapsible {
  constructor(options) {
    this.clickableElement = options["clickableElement"]
    this.collapsibleElement = options["collapsibleElement"]
  }

  init() {
    if (this.clickableElement.hasClass("nested")) {
      this.clickableElement.next(this.collapsibleElement).hide()
      this.clickableElement.on('click', (event) => {
        $(event.target).next(this.collapsibleElement).toggle()
      })
    }
    else {
      this.collapsibleElement.hide()
      this.clickableElement.on('click', () => {
        this.collapsibleElement.toggle()
      })
    }
  }
}