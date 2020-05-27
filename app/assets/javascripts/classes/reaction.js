// require("loading-overlay")
class Reaction {
  constructor(options) {
    this.eventGeneratorElement= options["eventGeneratorElement"]
  }
  init() {
    // this.eventGeneratorElement.on('ajax:send', function(event){
    //   $.LoadingOverlay("show")
    // })
    this.eventGeneratorElement.on('ajax:success', function(event,data,type){
      let a = data.reactable.reaction_count
      console.log(a)
      $(this).find($('.reaction_count')).text(a)
    })
    // this.eventGeneratorElement.on('ajax:success', function(event){
    //   $.LoadingOverlay("hide")
    // })
  }
}