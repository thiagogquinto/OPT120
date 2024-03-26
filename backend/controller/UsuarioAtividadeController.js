const database = require('../database/connection')

class UsuarioAtividadeController{

    newUsuarioAtividade(request, response){
        const {usuario_id, atividade_id, entrega, nota} = request.body;

        database.insert({usuario_id, atividade_id, entrega, nota}).table("usuario_atividade").then(data=>{
            response.json({message: "Entrega de atividade marcada com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }

    listUsuarioAtividades(request, response){
        database.select("*").table("usuario_atividade").then(usuario_atividades=>{
            response.json(usuario_atividades)
        }).catch(error=>{
            console.error(error)
        })
    }

    getUsuarioAtividade(request, response){
        const id = request.params.id;

        database.select("*").table("usuario_atividade").where({id:id}).then(usuario_atividade=>{
            response.json(usuario_atividade)
        }).catch(error=>{
            console.error(error)
        })
    }

    updateUsuarioAtividade(request, response){
        const id = request.params.id;
        const {usuario_id, atividade_id} = request.body;

        database.where({id:id}).update({usuario_id:usuario_id, atividade_id:atividade_id}).table("usuario_atividade").then(data=>{
            response.json({message: "Relacionamento atualizado com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }

    deleteUsuarioAtividade(request, response){
        const id = request.params.id;

        database.where({id:id}).del().table("usuario_atividade").then(data=>{
            response.json({message: "Relacionamento deletado com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }

}

module.exports = new UsuarioAtividadeController();
