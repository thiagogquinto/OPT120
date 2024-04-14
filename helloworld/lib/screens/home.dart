import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:helloworld/screens/atividade.dart';
import 'package:helloworld/screens/usuario_atividade.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  final int userId;
  final String userName;
  final String token;

  const Home(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.token})
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
              SizedBox(width: 5),
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
                              DataCell(atividade['entrega'] == '"-"'
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UsuarioAtividade(
                                                    userId: userId,
                                                    userName: userName,
                                                    token: token),
                                          ),
                                        );
                                      },
                                      child: Text(atividade['entrega']))
                                  : TextButton(
                                      onPressed: () {
                                        showEntregaDetails(
                                            context, atividade['id']);
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text('Infos'),
            ),
            ListTile(
              title: Text('Conta'),
              onTap: () {
                showUserDetails(context, userId);
              },
            ),
            ListTile(
              title: Text('Nova Atividade'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Atividade(
                      userId: userId,
                      userName: userName,
                      token: token,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<String> updateUser(BuildContext context, String nome, String email,
      String senha, int userId) async {
    final url = 'http://localhost:4000/updateUser/$userId';
    final response = await http.put(
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

    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return 'erro';
    }
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

  Future<Map<String, dynamic>> fetchUser(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:4000/getUser/$userId'));
      if (response.statusCode == 200) {
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
    _showEntregaDetailsDialog(context, nota);
  }

  void showUserDetails(BuildContext context, int userId) async {
    final user = await fetchUser(userId);
    print("object");
    print(user);
    _showUserDetailsDialog(context, userId, user);
  }

  void _showUserDetailsDialog(
      BuildContext context, int userId, Map<String, dynamic> user) {
    bool isEditing = false;
    TextEditingController nameController =
        TextEditingController(text: user['nome']);
    TextEditingController emailController =
        TextEditingController(text: user['email']);
    TextEditingController passwordController =
        TextEditingController(text: user['password']);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Usuário'),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      enabled: isEditing,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      enabled: isEditing,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      enabled: isEditing,
                      decoration: InputDecoration(labelText: 'Senha'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () => updateUser(
                          context,
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          userId),
                      child: Text('Atualizar usuário'),
                    )
                  ],
                ),
              );
            },
          );
        });
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
