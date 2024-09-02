import 'animal.dart';

class Vertebrado extends Animal {
  String tipo;

  Vertebrado({required String nome, required int idade, required this.tipo})
      : super(nome: nome, idade: idade);
}
