class Login {
  final String nick;

  final String senha;

  Login({required this.nick, required this.senha});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(nick: json['nick'], senha: json['senha']);
  }

  Map<String, dynamic> toJson() => {'nick': nick, 'senha': senha};
}
