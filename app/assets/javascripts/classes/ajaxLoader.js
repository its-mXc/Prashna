//= require gasparesganga-jquery-loading-overlay
class AjaxLoader {
  constructor(defaultSelector) {
    this.$document = $(document);
  }
  init() {
    this.$document.on('ajax:beforeSend', (event) => {
      $.LoadingOverlay("show",{imageColor: 'maroon'});
    }).on('ajax:complete', (event) => {
      $.LoadingOverlay("hide");
    });
  };
}