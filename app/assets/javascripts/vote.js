$(document).on('turbolinks:load', function() {
  let reaction_options = {
    eventGeneratorElement: $('.vote')
  }

  let vote = new Reaction(reaction_options)
  vote.init()
})