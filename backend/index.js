const express = require('express')
const cors = require('cors')

const router = require('./routes/routes')

const app = express()
app.use(cors())
app.use(express.json())

app.use(router)

app.listen(4000, ()=>
    console.log("Running on PORT 4000")
)

app.get('/', (request, response)=>{
    response.send("Hello World!")
})