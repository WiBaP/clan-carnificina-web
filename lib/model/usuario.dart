class Usuario {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String nick;
  final String classe;
  final String nivel;
  final String senha;
  final DateTime? dataConfirmacao;
  final bool? adm;

  Usuario({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.nick,
    required this.classe,
    required this.nivel,
    required this.senha,
    this.dataConfirmacao,
    this.adm,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      nick: json['nick'],
      classe: json['classe'],
      nivel: json['nivel'],
      senha: json['senha'],
      dataConfirmacao: json['data_confirmacao'] != null
          ? DateTime.parse(json['data_confirmacao'])
          : null,
      adm: json['adm'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'telefone': telefone,
    'email': email,
    'nick': nick,
    'classe': classe,
    'nivel': nivel,
    'senha': senha,
    'data_confirmacao': dataConfirmacao?.toIso8601String(),
    'adm': adm,
  };
}
