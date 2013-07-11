$(document).ready(function {
  $(':file').change(function(){
      var file = this.files[0];
      name = file.name;
      size = file.size;
      type = file.type;
  });
});

$(':button').click(function(){
    var formData = new FormData($('form')[0]);
    $.ajax({
        url: 'http://localhost:5000/file',  //server script to process data
        type: 'POST',
        xhr: function() {  // custom xhr
            var myXhr = $.ajaxSettings.xhr();
            if(myXhr.upload){ // check if upload property exists
                myXhr.upload.addEventListener('progress',progressHandlingFunction, false); // for handling the progress of the upload
            }
            return myXhr;
        },
        //Ajax events
        // beforeSend: beforeSendHandler,
        // success: completeHandler,
        // error: errorHandler,
        // Form data
        data: formData,
        //Options to tell JQuery not to process data or worry about content-type
        cache: false,
        contentType: false,
        processData: false
    });
});

function progressHandlingFunction(e){
    if(e.lengthComputable){
        $('progress').attr({value:e.loaded,max:e.total});
    }
}