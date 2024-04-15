const express = require('express')
const cors = require('cors')

const userRouter = require('./routes/UserRoutes')
const atividadeRouter = require('./routes/AtividadeRoutes')
const usuarioAtividadeRouter = require('./routes/UsuarioAtividadeRoutes')

const app = express()
app.use(cors())
app.use(express.json())

app.use(userRouter)
app.use(atividadeRouter)
app.use(usuarioAtividadeRouter)

app.listen(4000, ()=>
    console.log("Running on PORT 4000")
)

app.get('/', (request, response)=>{
    response.send("Hello World!")
})
