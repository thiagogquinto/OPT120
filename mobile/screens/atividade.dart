import "package:flutter/material.dart";
import "package:helloworld/theme.dart";
import "package:helloworld/widgets/atividade_form.dart";

class Atividade extends StatelessWidget {
  final int userId;
  final String userName;

  const Atividade({Key? key, required this.userId, required this.userName})
      : super(key: key);

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
              'Adicione uma atividade',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 10,
            ),
            AtividadeForm(userId: userId, userName: userName),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
