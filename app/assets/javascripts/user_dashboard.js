class AutoSubmitForm {
  constructor(options) {
    this.fileField = options['fileField']
    this.form = options['form']
  }
  init() {
    this.fileField.onchange = () => { this.form.submit(); };
  }
}

let options = {
  fileField: document.getElementById('user_avatar'),
  form: document.getElementById('avatar_form')
}

let autoSubmitForm = new AutoSubmitForm(options)
autoSubmitForm.init()