
const app_configuration = require('config'),
util = require('util'),
fs = require('fs'),
dbg = false;

exports.app_get = (req, res, next) => {
    fs.readFile('./config/appconfig.json', (err, data) => {
        if (err) {
            const error = new Error('Config file not found!');
            error.status = 404;
            return next(error);
        }
        let results = JSON.parse(data);
        console.log(results);
        res.body = results;
        res.status(200).json(results);
    });
};