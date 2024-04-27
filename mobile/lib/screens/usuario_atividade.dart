import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile/theme.dart';
import 'package:mobile/widgets/usuario_atividade_form.dart';

class UsuarioAtividade extends StatefulWidget {
  final int userId;
  final String userName;
  final String token;

  const UsuarioAtividade(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.token})
      : super(key: key);

  @override
  _UsuarioAtividadeState createState() => _UsuarioAtividadeState();
}

class _UsuarioAtividadeState extends State<UsuarioAtividade> {
  List<dynamic> atividades = [];

  @override
  void initState() {
    super.initState();
    fetchAtividades();
  }

  Future<void> fetchAtividades() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:4000/listAtividades'),
          headers: {'X-Access-Token': widget.token});
      if (response.statusCode == 200) {
        setState(() {
          atividades = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load atividades');
      }
    } catch (e) {
      print('Erro ao carregar atividades: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Text(
              'Adicione uma entrega',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 10,
            ),
            UsuarioAtividadeForm(
                userId: widget.userId,
                userName: widget.userName,
                token: widget.token,
                atividades: atividades),
            SizedBox(
              height: 20,
            ),
            // PrimaryButton(buttonText: 'Entrar')
          ],
        ),
      ),
    );
  }
}
