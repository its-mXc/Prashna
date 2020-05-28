$(document).on('turbolinks:load', function() { 
  let comments_collapsible_options = {
    clickableElement: $(".reply-btn"),
    collapsibleElement: $(".reply-form")
  }

  let commentscollapsibleComment = new Collapsible(comments_collapsible_options)
  commentscollapsibleComment.init()
  
  let comment_options = {
    scrollableElement: $(window.location.hash)
  }

  let comment_element = new ScrollIntoView(comment_options)
  comment_element.init()
})