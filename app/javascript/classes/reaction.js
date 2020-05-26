require("loading-overlay")
export class Reaction {
  constructor(options) {
    this.eventGeneratorElement= options["eventGeneratorElement"]
  }
  init() {
    this.eventGeneratorElement.on('ajax:send', function(event){
      $.LoadingOverlay("show")
    })
    this.eventGeneratorElement.on('ajax:success', function(event){
      $(this).find($('.reaction_count')).text(event.detail[0].reactable.reaction_count)
    })
    this.eventGeneratorElement.on('ajax:success', function(event){
      $.LoadingOverlay("hide")
    })
  }
}