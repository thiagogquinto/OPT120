const connection = require('../database/connection')
const express = require('express')
const router = express.Router()

const UserController = require('../controller/UserController')
const AtividadeController = require('../controller/AtividadeController')
const UsuarioAtividadeController = require('../controller/UsuarioAtividadeController')

router.post('/newUser', UserController.newUser)
router.get('/listUsers', UserController.listUsers)
router.get('/getUser/:id', UserController.getUser)
router.put('/updateUser/:id', UserController.updateUser)
router.delete('/deleteUser/:id', UserController.deleteUser)
router.post('/login', UserController.login)

router.post('/newAtividade', AtividadeController.newAtividade)
router.get('/listAtividades', AtividadeController.listAtividades)
router.get('/getAtividade/:id', AtividadeController.getAtividade)
router.put('/updateAtividade/:id', AtividadeController.updateAtividade)
router.delete('/deleteAtividade/:id', AtividadeController.deleteAtividade)

router.post('/newUsuarioAtividade', UsuarioAtividadeController.newUsuarioAtividade)
router.get('/listUsuarioAtividades', UsuarioAtividadeController.listUsuarioAtividades)
router.get('/getUsuarioAtividade/:id', UsuarioAtividadeController.getUsuarioAtividade)
router.put('/updateUsuarioAtividade/:id', UsuarioAtividadeController.updateUsuarioAtividade)
router.delete('/deleteUsuarioAtividade/:id', UsuarioAtividadeController.deleteUsuarioAtividade)
router.get('/hasEntrega/:atividade_id', UsuarioAtividadeController.hasEntrega)
router.get('/getEntrega/:atividade_id', UsuarioAtividadeController.getEntrega)

module.exports = router
