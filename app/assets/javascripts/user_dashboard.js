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
  // FIXME_AB: avoid two full page query. make a container and find inside container
  fileField: document.getElementById('user_avatar'),
  form: document.getElementById('avatar_form')
}

// FIXME_AB: should be done on page load, else html elements may not be available
let autoSubmitForm = new AutoSubmitForm(options)
autoSubmitForm.init()
