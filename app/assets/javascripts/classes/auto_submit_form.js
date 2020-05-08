//= require jquery
//= require jquery-ui/widgets/autocomplete

class AutoSubmitForm {
  constructor(options) {
    this.form = options['form']
    this.fileField = this.form.find(options['fileFieldId'])
  }
  init() {
    this.fileField.on('change',() => { this.form.submit(); })
  }
}

