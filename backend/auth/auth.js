const jwt = require('jsonwebtoken')
require('dotenv').config();

function generateToken(user){
    return jwt.sign(user, process.env.PRIVATE_SECRET, {
        expiresIn: '60m' 
    })
}

function verifyToken(token){
    try{
        const payload = jwt.verify(token, process.env.PRIVATE_SECRET)
        return true
    } catch(error){
        return false
    }
}

module.exports = { generateToken, verifyToken };
