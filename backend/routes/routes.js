const connection = require('../database/connection')
const express = require('express')
const router = express.Router()
const UserController = require('../controller/UserController')

router.post('/newUser', UserController.newUser)
router.get('/listUsers', UserController.listUsers)
router.get('/getUser/:id', UserController.getUser)
router.put('/updateUser/:id', UserController.updateUser)
router.delete('/deleteUser/:id', UserController.deleteUser)

module.exports = router
