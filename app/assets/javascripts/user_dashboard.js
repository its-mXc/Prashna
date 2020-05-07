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


$(document).ready(function() {
  let options = {
    form: $('#avatar_form'),
    fileFieldId: '#user_avatar'
  }
let autoSubmitForm = new AutoSubmitForm(options)
autoSubmitForm.init()
})

$("#notification-bell").on('click', function(){
  $("#notifications").toggle()
})

