$(document).on('turbolinks:load', function() {
  let answer_comments_collapsible_options = {
    clickableElement: $(".comments-btn"),
    collapsibleElement: $(".comments-answers")
  }
  
  let collapsibleComment = new Collapsible(answer_comments_collapsible_options)
  collapsibleComment.init()


})