const database = require('../database/connection')

class UserController{ 

    newUser(request, response){
        const {nome, email, password} = request.body;

        database.insert({nome, email, password}).table("usuario").then(data=>{
            response.status(201).json({message: "Usuário criado com sucesso!"})
        }).catch(error=>{
            response.status(400).json({message: "Erro ao criar usuário!"})
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
            response.status(200).json(user)
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
            if(user[0].password == password){
                response.status(200).json({id: user[0].id, nome: user[0].nome})

                console.log(response)
            }else{
                response.status(404).json({message: "Usuário não encontrado!"})
            }
        }).catch(error=>{
            response.status(400).json({message: "Erro ao realizar login!"})
        })
    }
}

module.exports = new UserController();
