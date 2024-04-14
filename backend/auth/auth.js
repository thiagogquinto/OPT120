const jwt = require('jsonwebtoken')
require('dotenv').config();

function generateToken(user){
    return jwt.sign(user, process.env.PRIVATE_SECRET, {
        expiresIn: 86400
    })
}

module.exports = generateToken;