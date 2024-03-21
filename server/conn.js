const mysql = require('mysql')

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'Fkzear75!',
  database: 'desenv_movel'
})

connection.connect()

connection.query('SHOW TABLES', (err, tables) => {
    if (err) throw err

   let tableLength = tables.length
    tables.forEach(table => {
      console.log(table.Tables_in_desenv_movel)
      const tableName = table.Tables_in_desenv_movel
      connection.query(`SELECT * FROM ${tableName}`, (err, rows) => {
        if (err) throw err
        console.log(`Data from ${tableName}`)
        console.log(rows)

        tableLength--
        if (tableLength === 0) {
          connection.end()
        }

      })
    })
})