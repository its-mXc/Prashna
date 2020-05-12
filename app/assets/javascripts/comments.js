// $('.reply-btn').next(".reply-form").hide()
// $('.reply-btn').on('click',function() {
//   $(this).next(".reply-form").toggle()
// })

$(document).ready(function() {
  
  let comments_collapsible_options = {
    clickableElement: $(".reply-btn"),
    collapsibleElement: $(".reply-form")
  }

  let collapsibleComment = new Collapsible(comments_collapsible_options)
  collapsibleComment.init()
})