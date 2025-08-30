import 'package:api_cadastro/model/usuario.dart';
import 'package:flutter/material.dart';
import '../service/login_service.dart';
import '../service/usuario_service.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final String? mensagem;
  const LoginScreen({super.key, this.mensagem});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nickController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.mensagem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(widget.mensagem!)));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioAutenticado();
  }

  void _verificarUsuarioAutenticado() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString('usuarioLogado');
    if (usuarioJson != null) {
      final data = jsonDecode(usuarioJson);
      final usuario = Usuario.fromJson(data);

      if (!mounted) return;

      if (usuario.adm == true) {
        context.go("/homeadm", extra: usuario);
      } else {
        context.go("/home", extra: usuario);
      }
    }
  }

  void _login() async {
    final nick = nickController.text.trim();
    final senha = senhaController.text;

    if (nick.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Preencha todos os campos")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final mensagem = await LoginService.login(nick, senha);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagem)));

      if (mensagem.toLowerCase().contains("sucesso")) {
        if (!mounted) return;

        // Buscar usuário no banco de dados para obter dados completos e verificar se é admin
        final usuarioLogado = await UsuarioService.getUsuarioPorNick(nick);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'usuarioLogado',
          jsonEncode(usuarioLogado.toJson()),
        );

        // Redireciona para a tela correta
        if (usuarioLogado.adm == true) {
          context.go("/homeadm", extra: usuarioLogado);
        } else {
          context.go("/home", extra: usuarioLogado);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro no login: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _irParaCadastro() {
    context.go("/cadastro");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nickController,
              decoration: const InputDecoration(
                labelText: "Nick",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: senhaController,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _irParaCadastro,
              child: const Text(
                "Ainda não tem cadastro? Registre-se aqui",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
