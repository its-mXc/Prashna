import {Collapsible} from '../classes/collapsible'
import {ScrollIntoView} from '../classes/scroll_into_view'
$(document).ready(function() {  
  
  let comments_collapsible_options = {
    clickableElement: $(".reply-btn"),
    collapsibleElement: $(".reply-form")
  }

  let collapsibleComment = new Collapsible(comments_collapsible_options)
  collapsibleComment.init()

  let comment_options = {
    scrollableElement: $(window.location.hash)
  }

  let comment_element = new ScrollIntoView(comment_options)
  comment_element.init()
})