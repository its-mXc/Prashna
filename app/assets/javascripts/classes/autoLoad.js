class AutoLoad {
  constructor(options) {
    this.persistentElement = options["persistentElement"]
    this.refershTime = this.persistentElement.data("refresh-time")
  }

  init() {
    this.persistentElement.hide();

    this.persistentElement.parent('form').on('ajax:success', function(event, data, type){
      $('.question-notification').children().remove()
      if(data.new_questions_size) {
        let paragraph = $('<p />').addClass("modal-open").text(`${data.new_questions_size} new Questions posted.Click to reload`)
        let modal = $('<div />').addClass('container alert alert-dismissible alert-success').append($('<button />').addClass('close').attr('type', 'buuton').data('dismiss', 'alert').text('x')).append(paragraph)
        paragraph.on('click', function() {
          window.location.reload()
        })
        $('.question-notification').append(modal)
      }

    });

    setInterval( () => {
      this.persistentElement.trigger("click")
    },this.refershTime)
  }
}
