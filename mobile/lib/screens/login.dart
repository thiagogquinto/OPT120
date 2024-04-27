import "package:flutter/material.dart";
import "package:mobile/theme.dart";
import "package:mobile/widgets/login_form.dart";
import 'signup.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Text(
              'Entre em sua conta',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Sem conta?',
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
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Cadastrar-se',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            LogInForm(),
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
