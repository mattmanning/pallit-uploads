if (!window.FileReader) {
  alert('The File API is not fully supported in this browser.');
  return;
}

function fileSize() {
  var input, file;

  input = document.getElementById('data');
  file = input.files[0];

  return file.size;
}

function addFileSize() {
  var form  = document.forms['upload'];
  var input = document.createElement('input');

  input.type  = 'hidden';
  input.name  = 'fsize';
  input.value = fileSize();

  form.insertBefore(input, form.childNodes[0]);

  // form.appendChild(input);
}

function fileSelected() {
  addFileSize();
}

var upload_id;

var socket = io.connect('http://localhost:5000');

socket.on('upload_id', function(data) {
  upload_id = data;
  document.forms['upload'].action = ('http://localhost:5000/file/' + upload_id);
});

socket.on('progress', function(data) {
  progress = document.getElementById('progress');
  progress.innerHTML = data.percent;
});

