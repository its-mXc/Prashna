console.log('hello')
import {Collapsible} from '../classes/collapsible'
$(document).on('ready', function(){
  let answer_comments_collapsible_options = {
    clickableElement: $(".comments-btn"),
    collapsibleElement: $(".comments-answers")
  }
  
  let collapsibleComment = new Collapsible(answer_comments_collapsible_options)
  collapsibleComment.init()

  console.log(answer_comments_collapsible_options)

})