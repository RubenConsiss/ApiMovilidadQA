const fs = require("fs");
const path = require("path");
const separator = ",";
function constructCsvLine(fields) {
  var encodedFields = [];
  for (var i = 0; i < fields.length; i++) {
    var field = "" + fields[i];

    if (field.includes('"')) field = `"${field.replace(/\"/g, '""')}"`; // replace single quotes with double quotes and enclose in quotes
    if (field.includes(separator)) field = `"${field}"`; // enclose in quotes when separator occurs in field
    if (field.includes("\n")) field = `"${field}"`; // enclose in quotes when newline occrus in field
    field = field.replace(/\n/g, "\r"); // seems to be parsed correctly as newline by Excel

    encodedFields.push(field);
  }
  return encodedFields.join(separator);
}

exports.createCsv = function (data, nombre) {
return(new Promise((resolve, reject) => {
 // construct csv output stream:
 //const outputPath = path.join(__dirname, `./../../assets/reportes/${nombre}.csv`);
 const output = fs.createWriteStream(`./assets/reportes/${nombre}.csv`, { encoding: "utf16le" });

 // add separator indication (So Excel knows what the CSV separator is):
 output.write(`sep=${separator}\n`);

 // if no data, end creation of file:
 if (data.length == 0) {
   output.end(() => {
    console.log("lvl write csv: data viene vacio");
   });
   reject("No Se creo csv vacio, var data no tiene datos")
 }

 // get headers from first entry:
 var headers = Object.keys(data[0]);

 // write headers to file:
 output.write(`${constructCsvLine(headers)}\n`);

 // write the rest of the data:
 for (var i = 0; i < data.length; i++) {
   var entry = data[i];

   var line = [];

   // only get fields that we have in our headers:
   for (var j = 0; j < headers.length; j++) {
     var key = headers[j];

     var field = entry[key];
     if (field === undefined) field = "";

     line.push(field);
   }

   output.write(`${constructCsvLine(line)}\n`);
 }
 output.end(() => {
   resolve(true)
 });
}))
};
