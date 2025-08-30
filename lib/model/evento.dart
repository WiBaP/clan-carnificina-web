class Evento {
  final int? id;
  final String titulo;
  final String? descricao;
  final DateTime dataEvento;
  final DateTime inicioInscricao;
  final DateTime fimInscricao;
  final String status;
  final int? limiteParticipantes;

  Evento({
    this.id,
    required this.titulo,
    this.descricao,
    required this.dataEvento,
    required this.inicioInscricao,
    required this.fimInscricao,
    this.status = "ativo",
    this.limiteParticipantes,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      dataEvento: DateTime.parse(json['data_evento']),
      inicioInscricao: DateTime.parse(json['inicio_inscricao']),
      fimInscricao: DateTime.parse(json['fim_inscricao']),
      status: json['status'] ?? "ativo",
      limiteParticipantes: json['limite_participantes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'data_evento': dataEvento.toIso8601String(),
    'inicio_inscricao': inicioInscricao.toIso8601String(),
    'fim_inscricao': fimInscricao.toIso8601String(),
    'status': status,
    'limite_participantes': limiteParticipantes,
  };
}
