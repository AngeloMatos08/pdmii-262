// 14-agregacao.dart
// Agregação e Composição

import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {'nome': _nome};
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar varios objetos Dependentes
  var dependente1 = Dependente("Ângelo");
  var dependente2 = Dependente("Henk");
  var dependente3 = Dependente("Luna");
  var dependente4 = Dependente("Gengar");

  // 2. Criar varios objetos Funcionario
  var funcionario1 = Funcionario("Ash", []);
  var funcionario2 = Funcionario("Misty", []);
  var funcionario3 = Funcionario("Brock", []);
  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios
  funcionario1._dependentes = [dependente1, dependente2];
  funcionario2._dependentes = [dependente3];
  funcionario3._dependentes = [dependente4];
  // 4. Criar uma lista de Funcionarios
  List<Funcionario> funcionarios = [funcionario1, funcionario2, funcionario3];
  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  var equipeProjeto = EquipeProjeto("Projeto Pokémon", funcionarios);
  // 6. Printar no formato JSON o objeto Equipe Projeto.
  var encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(equipeProjeto.toJson()));
}
