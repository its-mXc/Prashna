$(document).ready(function() {
  $('.vote').on('ajax:success', function(event){
    $(this).find($('.reaction_count')).text(event.detail[0].reactable.reaction_count)
  })
})