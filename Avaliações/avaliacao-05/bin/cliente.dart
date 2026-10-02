import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse('http://localhost:8080/alunos');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> dados = jsonDecode(response.body);
      final List<dynamic> listaAlunos = dados['alunos'];

      for (var item in listaAlunos) {
        final int id = item['id'];
        final String nome = item['nome'];
        final String disciplina = item['disciplina'];
        final double media = (item['media'] as num).toDouble();
        final int faltas = item['faltas'];

        String mensagem;

        if (faltas > 20) {
          mensagem = 'Reprovado por Faltas';
        } else if (media < 6.0) {
          mensagem = 'Reprovado';
        } else {
          mensagem = 'Aprovado';
        }

        print('$id $nome $disciplina $media $faltas $mensagem');
      }
    } else {
      print('Erro na requisição. Código HTTP: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao se conectar com o servidor: $e');
  }
}