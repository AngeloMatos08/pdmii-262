import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Inicializa o suporte FFI para o SQLite rodar no Dart puro (CLI)
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  // Define o caminho para criar o banco de dados na raiz do projeto
  String pathBanco = p.join(Directory.current.path, 'alunos.db');

  Database? db;

  try {
    print('--- INICIANDO CONEXÃO E CRIAÇÃO DO BANCO ---');

    // 1 e 2) Cria/Abre o banco e cria a tabela tb_alunos
    db = await databaseFactory.openDatabase(
      pathBanco,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          try {
            print('Criando a tabela tb_alunos...');
            await db.execute('''
              CREATE TABLE tb_alunos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                idade INTEGER NOT NULL
              )
            ''');
            print('Tabela tb_alunos criada com sucesso.');
          } catch (e) {
            print('Erro ao criar a tabela tb_alunos: $e');
            rethrow;
          }
        },
      ),
    );

    print('Banco de dados operacional em: $pathBanco');

    // 3) Inclui 3 alunos
    await inserindoAlunos(db);

    // 4) Lista o conteúdo da tabela
    await listarAlunos(db);

  } catch (e) {
    print('Exceção capturada no processo principal: $e');
  } finally {
    if (db != null && db.isOpen) {
      await db.close();
      print('\nConexão com o banco de dados encerrada.');
    }
  }
}

Future<void> inserindoAlunos(Database db) async {
  print('\n--- INSERINDO REGISTROS ---');
  List<Map<String, dynamic>> alunos = [
    {'nome': 'Henk Narciso', 'idade': 20},
    {'nome': 'Lucas Nazario', 'idade': 22},
    {'nome': 'Ângelo Matos', 'idade': 19},
    {'nome': 'Ednaldo Pereira', 'idade': 21},
    {'nome': 'Pedro Henrique', 'idade': 23},
    {'nome': 'José Rubens', 'idade': 20},
    {'nome': 'Joui Jouki', 'idade': 22},
    {'nome': 'Renato Russo', 'idade': 19},
    {'nome': 'Teste123', 'idade': 21},
    {'nome': 'George Harrison', 'idade': 23},
  ];

  for (var aluno in alunos) {
    try {
      int id = await db.insert('tb_alunos', aluno);
      print('Aluno inserido! ID: $id | Nome: ${aluno['nome']}');
    } catch (e) {
      print('Erro ao inserir o aluno ${aluno['nome']}: $e');
    }
  }
}

Future<void> listarAlunos(Database db) async {
  print('\n--- LISTANDO CONTEÚDO DA TABELA tb_alunos ---');
  try {
    List<Map<String, dynamic>> resultado = await db.query('tb_alunos');

    if (resultado.isEmpty) {
      print('Nenhum aluno encontrado.');
      return;
    }

    print('ID\t| Nome\t\t\t| Idade');
    print('---------------------------------------');
    for (var linha in resultado) {
      print('${linha['id']}\t| ${linha['nome'].toString().padRight(15)}\t| ${linha['idade']}');
    }
  } catch (e) {
    print('Erro ao listar os registros da tabela: $e');
  }
}