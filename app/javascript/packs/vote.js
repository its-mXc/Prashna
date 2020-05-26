import {Reaction} from '../classes/reaction'
$(document).ready(function() {
  let reaction_options = {
    eventGeneratorElement: $('.vote')
  }

  let vote = new Reaction(reaction_options)
  vote.init()
})