const connection = require('../database/connection')
const express = require('express')
const router = express.Router()

const UsuarioAtividadeController = require('../controller/UsuarioAtividadeController')

router.post('/newUsuarioAtividade', UsuarioAtividadeController.newUsuarioAtividade)
router.get('/getUsuarioAtividade/:id', UsuarioAtividadeController.getUsuarioAtividade)
router.put('/updateUsuarioAtividade/:id', UsuarioAtividadeController.updateUsuarioAtividade)
router.patch('/updateUsuarioAtividade/:id', UsuarioAtividadeController.updateUsuarioAtividadeNota)
router.delete('/deleteUsuarioAtividade/:id', UsuarioAtividadeController.deleteUsuarioAtividade)
router.get('/listUsuarioAtividades', UsuarioAtividadeController.listUsuarioAtividades)
router.get('/hasEntrega/:atividade_id', UsuarioAtividadeController.hasEntrega)
router.get('/getEntrega/:atividade_id', UsuarioAtividadeController.getEntrega)

module.exports = router
