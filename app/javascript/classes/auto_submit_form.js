export class AutoSubmitForm {
  constructor(options) {
    this.form = options['form']
    this.fileField = this.form.find(options['fileFieldId'])
  }
  init() {
    this.fileField.on('change',() => { this.form.submit(); })
  }
}

