import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usuario.dart';

class UsuarioService {
  static const String baseUrl = "https://carnificina-api-fastapi.vercel.app";

  // GET -> lista todos os usuários
  static Future<List<Usuario>> listarUsuarios() async {
    final response = await http.get(Uri.parse("$baseUrl/listar-usuario"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      // converte cada item JSON em Usuario
      return jsonData.map((item) => Usuario.fromJson(item)).toList();
    } else {
      throw Exception("Erro ao buscar usuários");
    }
  }

  // PUT -> atualizar usuário
  static Future<String> atualizarUsuario(Usuario usuario) async {
    final response = await http.put(
      Uri.parse("$baseUrl/atualizar-usuario"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(usuario.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data["mensagem"] ?? "Usuário atualizado!";
    } else {
      throw Exception("Erro ao atualizar o usuário: ${response.body}");
    }
  }

  static Future<String> alterarSenha(int id, String senha) async {
    final url = Uri.parse("$baseUrl/alterar-senha");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id, "senha": senha}),
      );

      if (response.statusCode == 200) {
        print("Senha alterada com sucesso");
        return "Senha alterada com sucesso";
      } else {
        print("Erro ao alterar senha: ${response.body}");
        return "Erro ao alterar senha: ${response.body}";
      }
    } catch (e) {
      print("Erro na requisição: $e");
      return "Erro na requisição: $e";
    }
  }

  // POST -> cadastrar usuário
  static Future<String> cadastrarUsuario(Usuario usuario) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cadastrar-usuario"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(usuario.toJson()),
    );

    final data = json.decode(response.body);

    // Se a API retornou erro no body
    if (data is Map && data.containsKey("erro")) {
      return data["erro"]; // retorna só a mensagem de erro
    }

    // Sucesso (status code ou body com mensagem)
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data["mensagem"] ?? "Usuário cadastrado com sucesso!";
    }

    return "Erro inesperado ao cadastrar usuário";
  }

  // GET -> Buscar usuário pelo nick
  static Future<Usuario> getUsuarioPorNick(String nick) async {
    final response = await http.get(
      Uri.parse("$baseUrl/usuario/${Uri.encodeComponent(nick)}"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Usuario.fromJson(data);
    } else {
      throw Exception("Erro ao buscar usuário: ${response.body}");
    }
  }
}
