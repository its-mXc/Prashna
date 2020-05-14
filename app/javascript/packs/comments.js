import {Collapsible} from '../classes/collapsible'
$(document).ready(function() {  
  let comments_collapsible_options = {
    clickableElement: $(".reply-btn"),
    collapsibleElement: $(".reply-form")
  }

  let collapsibleComment = new Collapsible(comments_collapsible_options)
  collapsibleComment.init()
})