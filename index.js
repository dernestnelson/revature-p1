const express = require('express');
const fileUpload = require('express-fileupload');
const app = express();
const path = require('path');

const port = 8080;
const hostname = '0.0.0.0';

/////////////////////
// const Sequelize = require('sequelize');

// // Option 1: Passing parameters separately
// const sequelize = new Sequelize('database', 'sqladmin', 'Password123', {
//   host: '0.0.0.0',
//   dialect: 'mysql'
// });

// var mysql = require('mysql')
// var connection = mysql.createConnection({
//   host: '0.0.0.0',
//   user: 'sqladmin',
//   password: 'Password123',
//   database: 'mydb'
// })

// connection.connect()

// connection.query('SELECT 1 + 1 AS solution', function (err, rows, fields) {
//   if (err) throw err

//   console.log('The solution is: ', rows[0].solution)
// })

// connection.end()

// mysql
//   .authenticate()
//   .then(() => {
//     console.log('Connection has been established successfully.');
//   })
//   .catch(err => {
//     console.error('Unable to connect to the database:', err);
//  });
///////////////////////

// default options
app.use(fileUpload());

app.get('/', function(req, res) {
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

 uploadPath = __dirname + '/uploads/' +  sampleFile.name;

    sampleFile.mv(uploadPath, function() {
  res.send(uploadPath);
    });
});


app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});