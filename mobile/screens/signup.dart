import 'package:flutter/material.dart';
import 'package:helloworld/screens/login.dart';
import 'package:helloworld/theme.dart';
import 'package:helloworld/widgets/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Criar Conta',
                style: titleText,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text(
                    'Já tem uma conta?',
                    style: subTitle,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInScreen()
                        )
                      );
                    },
                    child: Text(
                      'Entrar',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    )
                  )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: kDefaultPadding,
            child: SignUpForm(),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}
