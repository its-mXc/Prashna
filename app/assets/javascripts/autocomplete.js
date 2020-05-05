function split( val ) {
  return val.split( /,\s*/ );
}

function extractLast( term ) {
  return split( term ).pop();
}

class AutoCompleteInput {
  constructor(options) {
    this.inputElement = options["inputElement"]
  }

  init() {
    this.inputElement.autocomplete({
      source: function( request, response ) {
                $.getJSON( "/topics", {
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
  inputElement: $( "#tag-autocomplete" ),
}

let autoCompleteInput = new AutoCompleteInput(options)
autoCompleteInput.init()
