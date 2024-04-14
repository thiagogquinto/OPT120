import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helloworld/theme.dart';
import 'package:helloworld/screens/home.dart';
import 'package:http/http.dart' as http;

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInputForm('Email', false, _emailController),
        buildInputForm('Password', true, _senhaController),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              login(
                context,
                _emailController.text,
                _senhaController.text,
              );
            },
            child: Text('Entrar'))
      ],
    );
  }

  Padding buildInputForm(
      String label, bool pass, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: pass ? _isObscure : false,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: kTextFieldColor,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
            ),
            suffixIcon: pass
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: kPrimaryColor,
                    ),
                  )
                : null),
      ),
    );
  }

  Future<void> login(BuildContext context, String email, String senha) async {
    final url = 'http://localhost:4000/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Especifica que os dados são JSON
      },
      body: jsonEncode({
        'email': email,
        'password': senha,
      }),
    );

    if (response.statusCode == 200) {
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
