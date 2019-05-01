const express = require('express');
const fileUpload = require('express-fileupload');
const app = express();
const path = require('path');

const PORT = 8000;
app.use('/form', express.static(__dirname + '/fileUpload.html'));

// default options
app.use(fileUpload());

app.get('/', function(req, res) {
    //res.send('pong');
    res.sendFile(path.join(__dirname + '/fileUpload.html'));
});

app.post('/upload', function(req, res) {
  let sampleFile;
  let uploadPath;

  if (Object.keys(req.files).length == 0) {
    res.status(400).send('No files were uploaded.');
    return;
  }

  console.log('req.files >>>', req.files); // eslint-disable-line

  sampleFile = req.files.sampleFile;

  uploadPath = __dirname + '/uploads/' + sampleFile.name;
  

  sampleFile.mv(uploadPath, function() {
    //if (err) {
     // return res.status(500).send(err);
    //}

    res.send(uploadPath);
  });
});

app.listen(PORT, function() {
  console.log('Express server listening on port ', PORT); // eslint-disable-line
});