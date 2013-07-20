$(document).ready(function() {

    if (!window.FileReader) {
      alert('The File API is not fully supported in this browser.');
      return;
    }

    var pallitForm = new FormData();

    function progressHandlingFunction(e){
        if(e.lengthComputable){
            $('progress').attr({value:e.loaded,max:e.total});
        }
    }

    function clientProgressXHR() {
        var xhr = new XMLHttpRequest();
        if (xhr.upload) {
            xhr.upload.onprogress = progressHandlingFunction;
        }
        return xhr;
    }

    $('form.pallit input:submit').click(function(){
        var file = $('form.pallit input:file')[0].files[0];
        pallitForm.append('file-size', file.size);
        pallitForm.append('file', file);
        
        $.ajax({
            url: 'http://localhost:5000/file',  //server script to process data
            type: 'POST',
            xhr: clientProgressXHR,
            //Ajax events
            // beforeSend: function() {alert("Before send.");},
            success: function() {alert("Uploaded!");},
            error: function(exhr, etxt, err) {
                if (err) {
                    alert(etxt + "\n\n" + err);
                }
            },
            // Form data
            data: pallitForm,
            //Options to tell JQuery not to process data or worry about content-type
            cache: false,
            contentType: false,
            processData: false
        });
        return false;
    });
});