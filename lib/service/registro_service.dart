import 'dart:convert';

import 'package:http/http.dart' as http;
import '../model/registro.dart';

class RegistroEventoService {
  static const String baseUrl = "https://carnificina-api-fastapi.vercel.app";

  static Future<String> adicionarRegistro(int eventoId, String nick) async {
    final response = await http.post(
      Uri.parse("$baseUrl/adicionar-registro-evento"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"evento_id": eventoId, "nick": nick}),
    );

    if (response.statusCode == 200) {
      return "Registro adicionado com sucesso!";
    } else {
      throw Exception("Erro ao adicionar registro: ${response.body}");
    }
  }

  static Future<String> deletarRegistro(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/deletar-registro-evento/$id"),
    );

    if (response.statusCode == 200) {
      return "Registro removido com sucesso!";
    } else {
      throw Exception("Erro ao deletar registro: ${response.body}");
    }
  }

  static Future<String> deletarRegistroPorEventoENick(
    int eventoId,
    String nick,
  ) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/deletar-registro-evento/$eventoId/$nick"),
    );

    if (response.statusCode == 200) {
      return "Registro removido com sucesso!";
    } else {
      throw Exception("Erro ao deletar registro: ${response.body}");
    }
  }

  static Future<List<String>> listarUsuariosPorNick(
    int eventoId,
    String nick,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/listar-registro-evento/$eventoId/$nick"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((r) => r['nick'].toString()).toList();
    } else {
      throw Exception("Erro ao listar registros: ${response.body}");
    }
  }

  static Future<List<RegistroEvento>> listarEventos() async {
    final response = await http.get(
      Uri.parse("$baseUrl/listar-registro-evento"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => RegistroEvento.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao listar registros: ${response.body}");
    }
  }

  static Future<List<RegistroEvento>> listarPorEvento(int eventoId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/listar-registro-evento/$eventoId"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => RegistroEvento.fromJson(json)).toList();
    } else {
      throw Exception("Erro ao listar registros: ${response.body}");
    }
  }

  static Future<List<int>> listarEventosRegistrados(
    int eventoId,
    String nick,
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl/listar-registro-evento/$eventoId/$nick"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final registros = jsonList
          .map((json) => RegistroEvento.fromJson(json))
          .toList();
      return registros.map((r) => r.eventoId).toList();
    } else {
      throw Exception("Erro ao listar registros: ${response.body}");
    }
  }
}
