//const util  = require('util');
const mysql = require('mysql'),
      app_configuration = require('config');
//
//MySQL Connection Options
//Reference: https://www.npmjs.com/package/mysql#connection-options
//connectionLimit:1000,

const db_config = app_configuration.get('database_logs.mysql');

const pool = mysql.createPool(db_config);

pool.getConnection((err, connection) => {
    try {
        if (err) {
            if (err.code === 'PROTOCOL_CONNECTION_LOST') {
                console.error('Database connection was closed.');
            }
            if (err.code === 'ER_CON_COUNT_ERROR') {
                console.error('Database has too many connections.');
            }
            if (err.code === 'ECONNREFUSED') {
                console.error('Database connection was refused.');
            }
        }
        if (connection) connection.release();
        return;
    } catch(error) {
        if (connection) connection.release();
        error.status=500;
        throw error;
    }
});
//fix this
//pool.query = util.promisify(pool.query); // Magic happens here.

module.exports = pool;

//Reference: https://medium.com/@matthagemann/create-a-mysql-database-middleware-with-node-js-8-and-async-await-6984a09d49f4
