const connection = require('../database/connection')
const express = require('express')
const router = express.Router()

const UserController = require('../controller/UserController')

router.post('/login', UserController.login)
router.post('/newUser', UserController.newUser)
router.get('/getUser/:id', UserController.getUser)
router.put('/updateUser/:id', UserController.updateUser)
router.delete('/deleteUser/:id', UserController.deleteUser)
router.get('/listUsers', UserController.listUsers)

module.exports = router
