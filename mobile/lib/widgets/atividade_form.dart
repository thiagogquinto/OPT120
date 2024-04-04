import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/screens/home.dart';

class AtividadeForm extends StatefulWidget {
  final int userId;
  final String userName;

  const AtividadeForm({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  _AtividadeFormState createState() => _AtividadeFormState();
}

class _AtividadeFormState extends State<AtividadeForm> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _selectedDate;

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
      final url = 'http://localhost:4000/newAtividade';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'titulo': _tituloController.text,
          'descricao': _descricaoController.text,
          // 'data': _selectedDate,
          'dia': _selectedDate != null ? _selectedDate!.toString() : null,
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
          TextFormField(
            controller: _tituloController,
            decoration: InputDecoration(labelText: 'Título'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um título';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(labelText: 'Descrição'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma descrição';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              labelText: 'Data',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : '',
            ),
            // onPressed: () => _selectDate(context),
            // child: Text(_selectedDate != null
            //     ? 'Data selecionada: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
            //     : 'Selecione uma data'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => _createAtividade(context),
            child: Text('Adicionar Atividade'),
          ),
        ],
      ),
    );
  }
}
