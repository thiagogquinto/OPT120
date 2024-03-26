const database = require('../database/connection')

class UserController{ 

    newUser(request, response){
        const {nome, email, password} = request.body;

        database.insert({nome, email, password}).table("usuario").then(data=>{
            response.json({message: "Usuário criado com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }

    listUsers(request, response){
        database.select("*").table("usuario").then(users=>{
            response.json(users)
        }).catch(error=>{
            console.error(error)
        })
    }

    getUser(request, response){
        const id = request.params.id;

        database.select("*").table("usuario").where({id: id}).then(user=>{
            response.json(user)
        }).catch(error=>{
            console.error(error)
        })
    }

    updateUser(request, response){
        const id = request.params.id;
        const {nome, email, password} = request.body;

        database.where({id: id}).update({nome, email, password}).table("usuario").then(data=>{
            response.json({message: "Usuário atualizado com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }

    deleteUser(request, response){
        const id = request.params.id;

        database.where({id: id}).delete().table("usuario").then(data=>{
            response.json({message: "Usuário deletado com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }
}

module.exports = new UserController();
