// lib/service/login_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  // Substitua pelo seu endpoint real
  static const String baseUrl = "https://carnificina-api-fastapi.vercel.app";

  /// Faz login do usuário
  /// Retorna a mensagem do backend ou lança Exception em caso de erro
  static Future<String> login(String nick, String senha) async {
    final url = Uri.parse("$baseUrl/logar-usuario"); // ajuste conforme sua rota

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"nick": nick, "senha": senha}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = json.decode(response.body);
        // Retorna a mensagem do backend ou padrão
        return data["mensagem"] ?? "Login realizado com sucesso";
      } catch (e) {
        // Se não for JSON, retorna o corpo como string
        return response.body.isNotEmpty
            ? response.body
            : "Login realizado com sucesso";
      }
    } else {
      throw Exception("Erro no login: ${response.body}");
    }
  }
}
