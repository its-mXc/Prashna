// require("loading-overlay")
class Reaction {
  constructor(options) {
    this.eventGeneratorElement= options["eventGeneratorElement"]
  }
  init() {
    this.eventGeneratorElement.on('ajax:success', function(event,data,type){
      $(this).find($('.reaction_count')).text(data.reactable.reaction_count)
    })
  }
}