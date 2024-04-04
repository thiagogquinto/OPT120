import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/screens/home.dart';

class UsuarioAtividadeForm extends StatefulWidget {
  final int userId;
  final String userName;
  final List<dynamic> atividades;

  const UsuarioAtividadeForm(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.atividades})
      : super(key: key);

  @override
  _UsuarioAtividadeFormState createState() => _UsuarioAtividadeFormState();
}

class _UsuarioAtividadeFormState extends State<UsuarioAtividadeForm> {
  final _formKey = GlobalKey<FormState>();
  final _notaController = TextEditingController();
  DateTime? _selectedDate;
  int? _selectedAtividade;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _createAtividade(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final url = 'http://localhost:4000/newUsuarioAtividade';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'usuario_id': widget.userId,
          'atividade_id': _selectedAtividade,
          'nota': _notaController.text,
          'entrega': _selectedDate != null ? _selectedDate!.toString() : null,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      userId: widget.userId,
                      userName: widget.userName,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<int>(
            value: _selectedAtividade,
            onChanged: (value) {
              setState(() {
                _selectedAtividade = value;
              });
            },
            items: widget.atividades.map<DropdownMenuItem<int>>((atividade) {
              return DropdownMenuItem<int>(
                value: atividade['id'],
                child: Text(atividade['titulo']),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Atividade',
            ),
            validator: (value) {
              if (value == null) {
                return 'Por favor, selecione uma atividade';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _notaController,
            decoration: InputDecoration(labelText: 'Nota'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma nota';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              labelText: 'Data de Entrega',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : '',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => _createAtividade(context),
            child: Text('Adicionar Entrega'),
          ),
        ],
      ),
    );
  }
}
