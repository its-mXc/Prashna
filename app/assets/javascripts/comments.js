$('.reply-btn').next(".reply-form").hide()
$('.reply-btn').on('click',function() {
  $(this).next(".reply-form").toggle()
})