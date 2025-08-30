import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/usuario.dart';
import '../service/usuario_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nickController = TextEditingController();
  final TextEditingController nivelController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();
  final TextEditingController fusionController = TextEditingController();

  int? nivelMaximo = 120;
  bool mostrarFusion = false;

  String? classeSelecionada;
  bool isLoading = false;

  // Lista de classes válidas
  final List<String> classesValidas = [
    "assassin",
    "fighter",
    "knight",
    "atalanta",
    "archer",
    "pikeman",
    "mechanician",
    "magician",
    "shaman",
    "priestess",
  ];

  Future<void> _cadastrar() async {
    String nivelFinal = nivelController.text;

    if (mostrarFusion) {
      nivelFinal = "$nivelFinal+${fusionController.text}";
    }

    if (!_formKey.currentState!.validate()) return;

    // Verificar se senhas coincidem
    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("As senhas não coincidem")));
      return;
    }

    setState(() => isLoading = true);

    final usuario = Usuario(
      id: null,
      nome: nomeController.text,
      telefone: telefoneController.text,
      email: emailController.text,
      nick: nickController.text,
      classe: classeSelecionada ?? "",
      nivel: nivelFinal,
      senha: senhaController.text,
      dataConfirmacao: null,
      adm: null,
    );

    final mensagem = await UsuarioService.cadastrarUsuario(usuario);

    setState(() => isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));

    // Se a API retornar mensagem de sucesso, fecha a tela
    if (mensagem.toLowerCase().contains("sucesso")) {
      if (!mounted) return;
      // volta pra tela de login, sem transição
      context.go("/login", extra: "Cadastro realizado com sucesso!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o nome";
                  final regex = RegExp(r'^[A-Za-zÀ-ú\s]+$');
                  if (!regex.hasMatch(v))
                    return "Nome inválido (não use números)";
                  return null;
                },
              ),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone (+55 XX XXXXXXXX)",
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o telefone";
                  final regex = RegExp(r'^\+\d{1,3}\s?\d{4,14}$');
                  if (!regex.hasMatch(v))
                    return "Telefone inválido. Use +Código Número";
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o email";
                  final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                  if (!regex.hasMatch(v)) return "Email inválido";
                  return null;
                },
              ),
              TextFormField(
                controller: nickController,
                decoration: const InputDecoration(labelText: "Nick"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o nick" : null,
              ),
              DropdownButtonFormField<String>(
                value: classeSelecionada,
                items: classesValidas
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  setState(() => classeSelecionada = value);
                },
                decoration: const InputDecoration(labelText: "Classe"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Selecione uma classe" : null,
              ),
              // Campo Nível
              TextFormField(
                controller: nivelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nível (1-120)"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o nível";
                  final n = int.tryParse(v);
                  if (n == null) return "Digite um número válido";
                  if (n < 1 || n > 120) return "Nível deve ser entre 1 e 120";
                  return null;
                },
                onChanged: (v) {
                  final n = int.tryParse(v) ?? 0;
                  setState(() {
                    mostrarFusion = n == nivelMaximo;
                  });
                },
              ),

              // Se o usuário colocou 120, mostra Fusion Level
              if (mostrarFusion)
                TextFormField(
                  controller: fusionController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Fusion Level (≥120)",
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Informe o Fusion Level";
                    final f = int.tryParse(v);
                    if (f == null) return "Digite um número válido";
                    if (f < 120) return "Fusion Level deve ser 120 ou mais";
                    return null;
                  },
                ),

              TextFormField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Senha"),
                validator: (v) =>
                    v == null || v.length < 4 ? "Mínimo 4 caracteres" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirmar Senha"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Confirme a senha" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _cadastrar,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
