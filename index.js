const express = require('express');
const fileUpload = require('express-fileupload');
const app = express();
const path = require('path');
// const bodyparser = require('body-parser');
// const multer = require('multer');
// const upload = multer({ dest: './upload/'});
// const fs = require('fs');
// let directorypath = path.join(__dirname, '/upload/');
// const cosmos = require('@azure/cosmos').CosmosClient;

const port = 8080;
const hostname = '0.0.0.0';


/////////////////////
// async function run() {
//   // 1.
//   console.log("\n1. Create database, if it doesn't already exist '" + databaseId + "'");
//   await client.databases.createIfNotExists({ id: databaseId });
//   console.log("Database with id " + databaseId + " created.");

// console.log("1. create container with id '" + containerId + "'");
//   await database.containers.createIfNotExists({ id: containerId });

// console.log("\n1. insert items in to database '" + databaseId + "' and container '" + containerId + "'");
//   const itemDefs = getItemDefinitions();
//   const p = [];
//   for (const itemDef of itemDefs) {
//     p.push(container.items.create(itemDef));
//   }
//   await Promise.all(p);
//   console.log(itemDefs.length + " items created");



// //  @param {cosmos.Database} database

// async function useManualIndexing(database) {
//   console.log("create container with indexingPolicy.automatic : false");

//   const containerId = "ManualIndexDemo";
//   const indexingPolicySpec = { automatic: false };

//   const { container } = await database.containers.create({
//     id: containerId,
//     indexingPolicy: indexingPolicySpec
//   });


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

