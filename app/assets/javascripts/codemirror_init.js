var ready = function() {
  $("textarea.code").each(function(index, area) {
    var language = $(area).data('language');
    var mode = 'text/html';
    if(language == 'java') mode = 'text/x-java';

    var editor = CodeMirror.fromTextArea(area, {
      lineNumbers: true,
      styleActiveLine: true,
      matchBrackets: true,
      mode: mode,
      readOnly: true
    });
  });
};

$(document).ready(ready);
$(document).on("page:load", ready);