export class ScrollIntoView {
  constructor(options){
    this.scrollableElement = options["scrollableElement"]
  }

  init() {
    if (this.scrollableElement[0]) {
      this.scrollableElement[0].scrollIntoView()
    }
  }
}