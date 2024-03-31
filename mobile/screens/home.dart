import 'package:flutter/material.dart';
import 'package:helloworld/screens/atividade.dart';
import 'package:helloworld/screens/usuario_atividade.dart';

class Home extends StatelessWidget {
  final int userId;
  final String userName;

  const Home({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $userName'),
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Atividade(
                    userId: userId,
                    userName: userName,
                  )),
              );
            },
            child: Text('Adicionar Atividade')),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsuarioAtividade(
                    userId: userId,
                    userName: userName,
                  )
                ),
              );
            },
            child: Text('Adicionar Entrega')
          ),
        ],
      )),
    );
  }
}
