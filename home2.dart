import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:helloworld/screens/atividade.dart';
import 'package:helloworld/screens/usuario_atividade.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  final int userId;
  final String userName;

  const Home({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suas Atividades'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Atividade(
                        userId: userId,
                        userName: userName,
                      ),
                    ),
                  );
                },
                child: Text('Adicionar Atividade'),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsuarioAtividade(
                        userId: userId,
                        userName: userName,
                      ),
                    ),
                  );
                },
                child: Text('Adicionar Entrega'),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAtividades(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> atividades = snapshot.data!;
                  return Column(
                    children: [
                      DataTable(
                        columns: [
                          DataColumn(label: Text('Título')),
                          DataColumn(label: Text('Dia')),
                          DataColumn(label: Text('Entrega'))
                        ],
                        rows: atividades.map<DataRow>((atividade) {
                          return DataRow(
                            cells: [
                              DataCell(Text(atividade['titulo'])),
                              DataCell(Text(formatDate(atividade['dia']))),
                              // DataCell(Text(atividade['entrega']))
                              DataCell(TextButton(
                                onPressed: () {
                                  showEntregaDetails(context, atividade['id']);
                                  // _showEntregaDetailsDialog(
                                  //     context,
                                  //     atividade['entrega'],
                                  //     atividade['id']
                                  // );
                                },
                                child: Text(atividade['entrega']),
                                // atividade['entrega']
                              ))
                            ],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchAtividades() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:4000/listAtividades'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> atividades = [];
        for (var item in data) {
          String entrega = await hasEntrega(item['id']);
          atividades.add({
            'id': item['id'],
            'titulo': item['titulo'] as String,
            'dia': item['dia'] as String,
            'entrega': entrega
          });
        }
        return atividades;
      } else {
        throw Exception('Failed to load atividades');
      }
    } catch (e) {
      print('Erro ao carregar atividades: $e');
      return [];
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String formatEntrega(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  Future<String> hasEntrega(int atividade_id) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:4000/hasEntrega/$atividade_id'));
      if (response.statusCode == 200) {
        print('http://localhost:4000/hasEntrega/$atividade_id');
        print(response.body);
        // if (response.body != '') {
        // return formatEntrega(response.body);
        return response.body;
        // }
      } else {
        throw Exception('Failed to load entregas');
      }
    } catch (e) {
      print('Erro ao carregar entregas: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> fetchEntrega(int atividade_id) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:4000/getEntrega/$atividade_id'));
      if (response.statusCode == 200) {
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load entregas');
      }
    } catch (e) {
      print('Erro ao carregar entregas: $e');
      return {'nota': ''};
    }
  }

  void showEntregaDetails(BuildContext context, int atividade_id) async {
    final data = await fetchEntrega(atividade_id);
    int nota = data['nota'];
    print(nota);
    _showEntregaDetailsDialog(context, nota);
  }

  void _showEntregaDetailsDialog(BuildContext context, int nota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes da Entrega'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nota: $nota'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
