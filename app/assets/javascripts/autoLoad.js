$(document).on('turbolinks:load', function() {

  let autoReloadOptions = {
    persistentElement: $(".refresh_question_notification")
  }

  let persisistnetAutoLoad = new AutoLoad(autoReloadOptions)
  persisistnetAutoLoad.init()

})
