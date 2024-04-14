const database = require('../database/connection');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

require('dotenv').config();

const generateToken = require('../auth/auth')

class UserController{ 

    newUser(request, response){
        var {nome, email, password} = request.body;

        password = bcrypt.hashSync(password, 8);

        database.insert({nome, email, password}).table("usuario").then(data=>{
            const token = generateToken({id: data[0]})
            response.status(201).json({id: data[0], nome: nome, token: token, message: "Usuário criado com sucesso!"})
        }).catch(error=>{
            response.status(400).json({message: "Erro ao criar usuário!", error: error})
        })
    }

    listUsers(request, response){
        database.select("*").table("usuario").then(users=>{
            response.status(200).json(users)
        }).catch(error=>{
            response.status(400).json({message: "Erro ao listar usuários!"})
        })
    }

    getUser(request, response){
        const id = request.params.id;

        database.select("*").table("usuario").where({id: id}).then(user=>{
            response.status(200).json(user[0])
        }).catch(error=>{
            response.status(400).json({message: "Erro ao buscar usuário!"})
        })
    }

    updateUser(request, response){
        const id = request.params.id;
        const {nome, email, password} = request.body;

        database.where({id: id}).update({nome, email, password}).table("usuario").then(data=>{
           response.status(200).json({message: "Usuário atualizado com sucesso!"})
        }).catch(error=>{
            response.status(400).json({message: "Erro ao atualizar usuário!"})
        })
    }

    deleteUser(request, response){
        const id = request.params.id;

        database.where({id: id}).delete().table("usuario").then(data=>{
            response.status(200).json({message: "Usuário deletado com sucesso!"})
        }).catch(error=>{
            response.status(400).json({message: "Erro ao deletar usuário!"})
        })
    }

    login(request, response){
      
        const {email, password} = request.body;

        database.select("*").table("usuario").where({email: email}).then(user=>{

            const pass = bcrypt.compareSync(password, user[0].password)

            if(pass){
                const token = generateToken({id: user[0].id})
                response.status(200).json({id: user[0].id, nome: user[0].nome, token: token})
            }else{
                response.status(404).json({message: "Usuário não encontrado!"})
            }
        }).catch(error=>{
            response.status(400).json({message: "Erro ao realizar login!"})
        })
    }
}

module.exports = new UserController();
