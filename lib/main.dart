import 'package:flutter/material.dart';
import 'vertebrado.dart';

void main() {
  runApp(CrudApp());
}

class CrudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VertebradoListScreen(),
    );
  }
}

class VertebradoListScreen extends StatefulWidget {
  @override
  _VertebradoListScreenState createState() => _VertebradoListScreenState();
}

class _VertebradoListScreenState extends State<VertebradoListScreen> {
  List<Vertebrado> vertebrados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD animais vertebrados'),
      ),
      body: ListView.builder(
        itemCount: vertebrados.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(vertebrados[index].nome),
            subtitle: Text('Idade: ${vertebrados[index].idade} - Tipo: ${vertebrados[index].tipo}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  vertebrados.removeAt(index);
                });
              },
            ),
            onTap: () async {
              Vertebrado? updatedVertebrado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VertebradoFormScreen(vertebrado: vertebrados[index]),
                ),
              );

              if (updatedVertebrado != null) {
                setState(() {
                  vertebrados[index] = updatedVertebrado;
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Vertebrado? newVertebrado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VertebradoFormScreen()),
          );

          if (newVertebrado != null) {
            setState(() {
              vertebrados.add(newVertebrado);
            });
          }
        },
      ),
    );
  }
}

class VertebradoFormScreen extends StatefulWidget {
  final Vertebrado? vertebrado;

  VertebradoFormScreen({this.vertebrado});

  @override
  _VertebradoFormScreenState createState() => _VertebradoFormScreenState();
}

class _VertebradoFormScreenState extends State<VertebradoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late int _idade;
  late String _tipo;

  @override
  void initState() {
    super.initState();
    if (widget.vertebrado != null) {
      _nome = widget.vertebrado!.nome;
      _idade = widget.vertebrado!.idade;
      _tipo = widget.vertebrado!.tipo;
    } else {
      _nome = '';
      _idade = 0;
      _tipo = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vertebrado == null ? 'Novo animal' : 'Editar animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nome,
                decoration: InputDecoration(labelText: 'Nome'),
                onSaved: (value) {
                  _nome = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _idade.toString(),
                decoration: InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _idade = int.parse(value ?? '0');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a idade';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _tipo,
                decoration: InputDecoration(labelText: 'Tipo'),
                onSaved: (value) {
                  _tipo = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o tipo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(
                      context,
                      Vertebrado(nome: _nome, idade: _idade, tipo: _tipo),
                    );
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
