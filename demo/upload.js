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
  var input = document.createElement('input');
  var form  = document.forms[0];

  input.type  = 'hidden';
  input.name  = 'fsize';
  input.value = fileSize();

  form.insertBefore(input, form.childNodes[0]);
}

function fileSelected() {
  addFileSize();
}

