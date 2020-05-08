$(document).ready(function() {
  let avatar_auto_submit_options = {
    form: $('#avatar_form'),
    fileFieldId: '#user_avatar'
  }

  let avatar_auto_submit= new AutoSubmitForm(avatar_auto_submit_options)
  avatar_auto_submit.init()

  let topic_auto_complete_profile = {
    // FIXME_AB: add topics url as data-attribute to this element using rails url helper
    inputElement: $( "#tag-autocomplete" ),
  }
  
  let profile_topic_autocomplete = new AutoCompleteInput(topic_auto_complete_profile)
  profile_topic_autocomplete.init()
  
  $("#notification-bell").on('click', function(){
    $("#notifications").toggle()
  })
})


