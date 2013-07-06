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
