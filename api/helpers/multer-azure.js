
const multer = require('multer'),
      multerAzure = require('multer-azure'),
      app_configuration = require('config');

const fileFilter = (req, file, cb) => {
    // reject a file
    if (file.mimetype === 'image/jpeg' || 
    file.mimetype === 'image/png') {
      cb(null, true);
    } else {
      cb(null, false);
    }
};

var uploadMulterAzure = multer({
    storage: multerAzure({
      connectionString: app_configuration.get('azure.sas.connection_string'), //'[Azure Storage Connection String]', //Connection String for azure storage account, this one is prefered if you specified, fallback to account and key if not.
      //account: '[Azure Storage Account]', //The name of the Azure storage account
      //key: '[Azure Storage Account Key]', //A key listed under Access keys in the storage account pane
      container: app_configuration.get('azure.sas.blob.containers.observaciones.name') // '[Blob Container Name]'  //Any container name, it will be created if it doesn't exist
      //blobPathResolver: function(req, file, callback) {
      //  var blobPath = yourMagicLogic(req, file); //Calculate blobPath in your own way.
      //  callback(null, blobPath);
      //}
    }),
    limits: {
        fileSize: app_configuration.get('azure.sas.blob.upload_max_filesize') //1024 * 1024 * 5
      },
      fileFilter: fileFilter
  });

  module.exports = uploadMulterAzure;