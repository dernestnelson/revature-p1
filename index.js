const express = require('express');
const fileUpload = require('express-fileupload');
const app = express();
const path = require('path');

const port = 8080;
const hostname = '0.0.0.0';


// default options
app.use(fileUpload());

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname + '/fileUpload.html'));
});

app.post('/upload', function(req, res) {
  res.redirect('/');
  let sampleFile;
  let uploadPath;

  if (Object.keys(req.files).length == 0) {
    res.status(400).send('No files were uploaded.');
    return;
  }

  console.log('req.files >>>', req.files); // eslint-disable-line

 sampleFile = req.files.sampleFile;

 uploadPath = __dirname + '/uploads/' +  sampleFile.name;

    sampleFile.mv(uploadPath, function() {
  res.send(uploadPath);
    });
});


app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
