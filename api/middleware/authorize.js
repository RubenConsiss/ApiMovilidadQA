
const jwt = require('jsonwebtoken');
var app_configuration = require('config');

module.exports = (req, res, next) => {
    try {
        const token = req.headers.authorization.split(" ")[1];
        const apiJwtKey = app_configuration.get('application.api_jwt_key');
        const decoded = jwt.verify(token, apiJwtKey);
        req.tokenData = decoded;
        next();
    } catch(error) {
        error.status = 401;
        return next(error);
    }
};