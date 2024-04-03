const { parse } = require('dotenv');
const database = require('../database/connection')

class UsuarioAtividadeController{

    newUsuarioAtividade(request, response){
        const {usuario_id, atividade_id, entrega} = request.body;

        let nota = request.body.nota;
        nota = parseFloat(nota);

        console.log(usuario_id, atividade_id, entrega, nota)

        database.insert({usuario_id, atividade_id, entrega, nota}).table("usuario_atividade").then(data=>{
            response.status(200).json({message: "Entrega de atividade marcada com sucesso!"})
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

    hasEntrega(request, response){
        const atividade_id = request.params.atividade_id;
    
        database.select("entrega").table("usuario_atividade").where({atividade_id: atividade_id}).then(entrega=>{
            if(entrega.length > 0) {
                console.log(entrega[0].entrega)
                let data = new Date(entrega[0].entrega);
                let dia = data.getDate();
                let mes = data.getMonth() + 1;
                let ano = data.getFullYear();
                console.log(`${dia}/${mes}/${ano}`)
                response.status(200).json(`${dia}/${mes}/${ano}`);
            } else {
                response.status(200).json('-');
            }
        }).catch(error=>{
            console.error(error)
        })
    }

    getEntrega(request, response){
        const atividade_id = request.params.atividade_id;
        console.log(atividade_id)
    
        database.select("*").table("usuario_atividade").where({atividade_id: atividade_id}).then(entrega=>{
            if(entrega.length > 0) {
                console.log(entrega[0])
                response.status(200).json(entrega[0]);
            } else {
                response.status(200).json('-');
            }
        }).catch(error=>{
            console.error(error)
        })
    }
}

module.exports = new UsuarioAtividadeController();
