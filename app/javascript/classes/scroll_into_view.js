export class ScrollIntoView {
  constructor(options){
    this.scrollableElement = options["scrollableElement"]
  }

  init() {
    if (this.scrollableElement[0]) {
      if(this.scrollableElement.closest('.comments-answers')[0]) {
        this.scrollableElement.closest('.comments-answers').show()
      }
      else {
        $(`a[href*=${this.scrollableElement.attr('id').replace(/\-.*/,'')}]`)[0].click()
      }
      this.scrollableElement[0].scrollIntoView()
    }
  }
}