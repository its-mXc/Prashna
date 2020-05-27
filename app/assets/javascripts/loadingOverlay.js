$(document).on("turbolinks:load", function(){
  let defaultSelector = {
  };
    let ajaxLoaderObj = new AjaxLoader(defaultSelector);
    ajaxLoaderObj.init();
});