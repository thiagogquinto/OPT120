const database = require('../database/connection')

const { verifyToken } = require('../auth/auth');

class AtividadeController{

    newAtividade(request, response){
        const {titulo, descricao, dia} = request.body;
        const token = request.headers['x-access-token'];
        const verified = verifyToken(token);

        if(!verified){
            response.status(401).json({message: "Token inválido!"})
        }

        database.insert({titulo, descricao, dia}).table("atividade").then(data=>{
            response.json({message: "Atividade criada com sucesso!"})
        }).catch(error=>{
            console.error(error)
            response.status(500).json({message: "Erro ao criar atividade!"})
        })
    }

    listAtividades(request, response){
        const token = request.headers['x-access-token'];
        const verified = verifyToken(token);

        if(!verified){
            response.status(401).json({message: "Token inválido!"})
        }

        database.select("*").table("atividade").then(atividades=>{
            response.status(200).json(atividades)
        }).catch(error=>{
            console.error(error)
            response.status(500).json({message: "Erro ao listar atividades!"})
        })
    }

    getAtividade(request, response){
        const token = request.headers['x-access-token'];
        const verified = verifyToken(token);

        if(!verified){
            response.status(401).json({message: "Token inválido!"})
        }

        const id = request.params.id;

        database.select("*").table("atividade").where({id:id}).then(atividade=>{
            response.json(atividade)
        }).catch(error=>{
            console.error(error)
            response.status(500).json({message: "Erro ao buscar atividade!"})
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
