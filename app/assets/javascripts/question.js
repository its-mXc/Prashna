$(document).ready(function() {
  let questions_topics_autocomplete_options = {
    // FIXME_AB: add topics url as data-attribute to this element using rails url helper
    inputElement: $( "#tag-autocomplete" ),
  }

  let question_topics_autocomplete = new AutoCompleteInput(questions_topics_autocomplete_options)
  question_topics_autocomplete.init()
  
})
