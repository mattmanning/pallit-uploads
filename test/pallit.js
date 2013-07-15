$(document).ready(function() {

    if (!window.FileReader) {
      alert('The File API is not fully supported in this browser.');
      return;
    }

    var pallitForm = new FormData();

    // $('form.pallit input:file').change(function(){
    //     var file = this.files[0];
    //     pallitForm.append('file-size', file.size);
    //     pallitForm.append('file', file);
    // });

    $('form.pallit input:submit').click(function(){
        alert("Clicked");
        var file = $('form.pallit input:file')[0].files[0];
        pallitForm.append('file-size', file.size);
        pallitForm.append('file', file);
        
        $.ajax({
            url: 'http://localhost:5000/file',  //server script to process data
            type: 'POST',
            // xhr: function() {  // custom xhr
            //     var myXhr = $.ajaxSettings.xhr();
            //     if(myXhr.upload){ // check if upload property exists
            //         myXhr.upload.addEventListener('progress',progressHandlingFunction, false); // for handling the progress of the upload
            //     }
            //     return myXhr;
            // },
            //Ajax events
            beforeSend: function() {alert("Before send.");},
            success: function() {alert("Uploaded!");},
            error: function() {alert("Error!");},
            // Form data
            data: pallitForm,
            //Options to tell JQuery not to process data or worry about content-type
            cache: false,
            contentType: false,
            processData: false
        });

        alert("Completed");
    });

    function progressHandlingFunction(e){
        if(e.lengthComputable){
            $('progress').attr({value:e.loaded,max:e.total});
        }
    }
});