const connection = require('../database/connection')
const express = require('express')
const router = express.Router()

const AtividadeController = require('../controller/AtividadeController')

router.post('/newAtividade', AtividadeController.newAtividade)
router.get('/getAtividade/:id', AtividadeController.getAtividade)
router.put('/updateAtividade/:id', AtividadeController.updateAtividade)
router.delete('/deleteAtividade/:id', AtividadeController.deleteAtividade)
router.get('/listAtividades', AtividadeController.listAtividades)

module.exports = router
