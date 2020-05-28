$(document).on('turbolinks:load', function() {
  let questions_topics_autocomplete_options = {
    inputElement: $( "#tag-autocomplete" ),
  }

  let question_topics_autocomplete = new AutoCompleteInput(questions_topics_autocomplete_options)
  question_topics_autocomplete.init()
  
})
