require("jquery-ui")

import {split, extractLast} from '../modules/utils'
export class AutoCompleteInput {
  constructor(options) {
    this.inputElement = options["inputElement"]
  }

  init() {
    this.inputElement.autocomplete({
      source: function( request, response ) {
                $.getJSON( this.element.data('jsonurl'), {
                  term: extractLast( request.term )
                }, response );
              },
      select: function( event, ui ) {
                // Add the selected term appending to the current values with a comma
                var terms = split( this.value );
                // remove the current input
                terms.pop();
                // add t  he selected item
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
