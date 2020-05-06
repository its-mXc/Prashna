// FIXME_AB: why these are global functions. You can make Utils module and add them there

class AutoCompleteInput {
  constructor(options) {
    this.inputElement = options["inputElement"]
    this.inputElement.data("JSONURL", options["JSONURL"])
    // FIXME_AB:     this.topics_url = this.inputElement.data('topics_url')
  }

  init() {
    this.inputElement.autocomplete({
      source: function( request, response ) {
                // FIXME_AB: we should not hardcode this url. get it from elment
                $.getJSON( this.element.data('JSONURL'), {
                  term: extractLast( request.term )
                }, response );
              },
      select: function( event, ui ) {
                // Add the selected term appending to the current values with a comma
                var terms = split( this.value );
                // remove the current input
                terms.pop();
                // add the selected item
                terms.push( ui.item.value );
                // join all terms with a comma
                this.value = terms.join( ", " );
                return false;
              },
      focus: function() {
               // prevent value inserted on focus when navigating the drop down list
               return false;
             }
    });
  }
}


let options = {
  // FIXME_AB: add topics url as data-attribute to this element using rails url helper
  inputElement: $( "#tag-autocomplete" ),
  JSONURL: "/topics"
}

let autoCompleteInput = new AutoCompleteInput(options)
autoCompleteInput.init()