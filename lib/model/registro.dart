class RegistroEvento {
  final int? id;
  final int eventoId;
  final String nick;
  final DateTime? dataRegistro;

  RegistroEvento({
    this.id,
    required this.eventoId,
    required this.nick,
    this.dataRegistro,
  });

  factory RegistroEvento.fromJson(Map<String, dynamic> json) {
    return RegistroEvento(
      id: json['id'],
      eventoId: json['evento_id'],
      nick: json['nick'],
      dataRegistro: json['data_registro'] != null
          ? DateTime.parse(json['data_registro'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "evento_id": eventoId,
      "nick": nick,
      "data_registro": dataRegistro?.toIso8601String(),
    };
  }
}
