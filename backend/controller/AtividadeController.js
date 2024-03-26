const database = require('../database/connection')

class AtividadeController{

    newAtividade(request, response){
        const {titulo, descricao, dia} = request.body;

        database.insert({titulo, descricao, dia}).table("atividade").then(data=>{
            response.json({message: "Atividade criada com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }

    listAtividades(request, response){
        database.select("*").table("atividade").then(atividades=>{
            response.json(atividades)
        }).catch(error=>{
            console.error(error)
        })
    }

    getAtividade(request, response){
        const id = request.params.id;

        database.select("*").table("atividade").where({id:id}).then(atividade=>{
            response.json(atividade)
        }).catch(error=>{
            console.error(error)
        })
    }

    updateAtividade(request, response){
        const id = request.params.id;
        const {titulo, descricao, dia} = request.body;

        database.where({id:id}).update({titulo:titulo, descricao:descricao, dia:dia}).table("atividade").then(data=>{
            response.json({message: "Atividade atualizada com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }

    deleteAtividade(request, response){
        const id = request.params.id;

        database.where({id:id}).del().table("atividade").then(data=>{
            response.json({message: "Atividade deletada com sucesso!"})
        }).catch(error=>{
            console.error(error)
        })
    }
    
}

module.exports = new AtividadeController();
