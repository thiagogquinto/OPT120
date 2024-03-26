require('dotenv').config()

var knex = require('knex')({
    client: 'mysql',
    connection: {
        host: 'localhost',
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        connTimeout: 10000,
    }
});

module.exports = knex;
