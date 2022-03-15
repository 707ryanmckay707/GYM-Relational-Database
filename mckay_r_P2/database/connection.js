const mysql = require('mysql');

const connection = mysql.createConnection({
    debug: true,
    connection: '127.0.0.1',
    port: '3306',
    database: 'rmckay_cs355sp21',
    user: 'rmckay_cs355sp21',
    password: 'mc7639106'
});

module.exports = connection;
