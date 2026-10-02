import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class Aluno {
  final int id;
  final String nome;
  final String disciplina;
  final double media;
  final int faltas;

  const Aluno({
    required this.id,
    required this.nome,
    required this.disciplina,
    required this.media,
    required this.faltas,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'disciplina': disciplina,
      'media': media,
      'faltas': faltas,
    };
  }
}

final List<Aluno> alunos = [
  const Aluno(
    id: 1,
    nome: 'Guilherme Alves',
    disciplina: 'Sistemas Distribuídos',
    media: 8.5,
    faltas: 4,
  ),
  const Aluno(
    id: 2,
    nome: 'Ana Katherine',
    disciplina: 'Programação Web',
    media: 5.2,
    faltas: 10,
  ),
  const Aluno(
    id: 3,
    nome: 'Igor Thiago',
    disciplina: 'Banco de Dados',
    media: 9.0,
    faltas: 22,
  ),
  const Aluno(
    id: 4,
    nome: 'Davi Alonso',
    disciplina: 'Engenharia de Software',
    media: 4.5,
    faltas: 25,
  ),
];

Response respostaJson(dynamic dados, {int statusCode = HttpStatus.ok}) {
  return Response(
    statusCode,
    body: jsonEncode(dados),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    },
  );
}

Router criarRotas() {
  final router = Router();

  router.get('/alunos', (Request request) {
    return respostaJson({
      'total': alunos.length,
      'alunos': alunos.map((aluno) => aluno.toJson()).toList(),
    });
  });

  return router;
}

Future<void> main() async {
  final router = criarRotas();
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Servidor iniciado em http://${server.address.host}:${server.port}');
}