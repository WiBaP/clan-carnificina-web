import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/evento.dart';

class EventoService {
  static const String baseUrl = "https://carnificina-api-fastapi.vercel.app";

  // GET -> lista todos os eventos
  static Future<List<Evento>> listarEventos() async {
    final response = await http.get(Uri.parse("$baseUrl/listar-evento"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Evento.fromJson(item)).toList();
    } else {
      throw Exception("Erro ao buscar eventos");
    }
  }

  // GET -> buscar evento por ID
  static Future<Evento> getEventoPorId(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/evento/$id"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Evento.fromJson(data);
    } else {
      throw Exception("Erro ao buscar evento: ${response.body}");
    }
  }

  // POST -> cadastrar evento
  static Future<String> cadastrarEvento(Evento evento) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cadastrar-evento"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(evento.toJson()),
    );

    final data = json.decode(response.body);

    if (data is Map && data.containsKey("erro")) {
      return data["erro"];
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data["mensagem"] ?? "Evento cadastrado com sucesso!";
    }

    return "Erro inesperado ao cadastrar evento";
  }

  // PUT -> atualizar evento
  static Future<String> atualizarEvento(Evento evento) async {
    final response = await http.put(
      Uri.parse("$baseUrl/atualizar-evento"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(evento.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data["mensagem"] ?? "Evento atualizado!";
    } else {
      throw Exception("Erro ao atualizar o evento: ${response.body}");
    }
  }

  // DELETE -> excluir evento por ID
  static Future<String> excluirEvento(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/deletar-evento/$id"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["mensagem"] ?? "Evento excluído com sucesso!";
    } else {
      throw Exception("Erro ao excluir evento: ${response.body}");
    }
  }
}
