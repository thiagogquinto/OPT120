import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/theme.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/home.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isObscure = true;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  // final _confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('Nome', false, _nomeController),
        buildInputForm('Email', false, _emailController),
        buildInputForm('Senha', true, _senhaController),
        // buildInputForm('Confirme a senha', true, _confirmarSenhaController),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              createUser(
                context,
                _nomeController.text,
                _emailController.text,
                _senhaController.text,
              );
            },
            child: Text('Criar Conta'))
      ],
    );
  }

  Padding buildInputForm(
      String hint, bool pass, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kTextFieldColor),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          suffixIcon: pass
              ? IconButton(
                  onPressed: () {},
                  icon: _isObscure
                      ? Icon(
                          Icons.visibility_off,
                          color: kPrimaryColor,
                        )
                      : Icon(
                          Icons.visibility,
                          color: kPrimaryColor,
                        ),
                )
              : null,
        ),
      ),
    );
  }

  Future<void> createUser(
      BuildContext context, String nome, String email, String senha) async {
    final url = 'http://localhost:4000/newUser';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Especifica que os dados são JSON
      },
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'password': senha,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final userId = jsonResponse['id'];
      final userName = jsonResponse['nome'];
      final token = jsonResponse['token'];

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Home(userId: userId, userName: userName, token: token)),
      );
    }
  }
}
