// lib/screens/usuario_screen.dart
import 'package:flutter/material.dart';
import '../model/usuario.dart';
import '../service/usuario_service.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  late Future<List<Usuario>> futureUsuarios;

  @override
  void initState() {
    super.initState();
    futureUsuarios = UsuarioService.listarUsuarios();
  }

  String getClasseImagePath(String classe) {
    switch (classe.toLowerCase()) {
      case "assassin":
        return "assets/classes/ass.png";
      case "fighter":
        return "assets/classes/fs.png";
      case "knight":
        return "assets/classes/ks.png";
      case "atalanta":
        return "assets/classes/ata.png";
      case "archer":
        return "assets/classes/as.png";
      case "pikeman":
        return "assets/classes/ps.png";
      case "mechanician":
        return "assets/classes/ms.png";
      case "magician":
        return "assets/classes/mage.jpg";
      case "shaman":
        return "assets/classes/ss.png";
      case "priestess":
        return "assets/classes/prs.png";
      default:
        return "assets/classes/default.png";
    }
  }

  // --- popup para editar usuário ---
  void abrirEditarUsuario(BuildContext context, Usuario usuario) {
    final _formKey = GlobalKey<FormState>();
    final nomeCtrl = TextEditingController(text: usuario.nome);
    final emailCtrl = TextEditingController(text: usuario.email);
    final telCtrl = TextEditingController(text: usuario.telefone);
    final nickCtrl = TextEditingController(text: usuario.nick);
    final nivelCtrl = TextEditingController(text: usuario.nivel);
    String classe = usuario.classe;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Usuário"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: "Nome"),
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextFormField(
                  controller: telCtrl,
                  decoration: const InputDecoration(labelText: "Telefone"),
                ),
                TextFormField(
                  controller: nickCtrl,
                  decoration: const InputDecoration(labelText: "Nick"),
                ),
                TextFormField(
                  controller: nivelCtrl,
                  decoration: const InputDecoration(labelText: "Level"),
                ),
                DropdownButtonFormField<String>(
                  value: classe,
                  items:
                      [
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
                          ]
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                  onChanged: (v) => classe = v!,
                  decoration: const InputDecoration(labelText: "Classe"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final editado = Usuario(
                id: usuario.id,
                nick: nickCtrl.text,
                classe: classe,
                nivel: nivelCtrl.text,
                nome: nomeCtrl.text,
                email: emailCtrl.text,
                telefone: telCtrl.text,
                senha: usuario.senha,
                dataConfirmacao: usuario.dataConfirmacao,
                adm: usuario.adm,
              );

              try {
                await UsuarioService.atualizarUsuario(editado);
                if (context.mounted) {
                  Navigator.pop(context);
                  setState(() {
                    futureUsuarios = UsuarioService.listarUsuarios();
                  });
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                }
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  // --- popup para alterar senha ---
  void abrirAlterarSenha(BuildContext context, Usuario usuario) {
    final _formKey = GlobalKey<FormState>();
    final senhaCtrl = TextEditingController();
    final confirmaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Alterar Senha"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: senhaCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Nova Senha"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe a senha";
                  if (v.length < 4) return "Mínimo 4 caracteres";
                  return null;
                },
              ),
              TextFormField(
                controller: confirmaCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirmar Senha"),
                validator: (v) =>
                    v != senhaCtrl.text ? "Senhas não coincidem" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              try {
                // ⬇️ Aqui passamos id e senha (não o objeto inteiro)
                final msg = await UsuarioService.alterarSenha(
                  usuario.id!,
                  senhaCtrl.text,
                );

                if (context.mounted) {
                  Navigator.pop(context); // fecha o popup
                  setState(() {
                    // recarrega lista de usuários
                    futureUsuarios = UsuarioService.listarUsuarios();
                  });

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                }
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  // --- alternar admin clicando na estrela ---
  Future<void> alternarAdmin(Usuario usuario) async {
    final novoStatus = !(usuario.adm ?? false);

    final editado = Usuario(
      id: usuario.id,
      nick: usuario.nick,
      classe: usuario.classe,
      nivel: usuario.nivel,
      nome: usuario.nome,
      email: usuario.email,
      telefone: usuario.telefone,
      senha: usuario.senha,
      dataConfirmacao: usuario.dataConfirmacao,
      adm: novoStatus,
    );

    try {
      await UsuarioService.atualizarUsuario(editado);

      // 🔑 pega a nova lista fora do setState
      final listaAtualizada = UsuarioService.listarUsuarios();

      if (mounted) {
        setState(() {
          futureUsuarios = listaAtualizada; // ✅ só atribuição síncrona
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              novoStatus
                  ? "Esse usuário agora é admin"
                  : "Esse usuário não é mais admin",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuários")),
      body: FutureBuilder<List<Usuario>>(
        future: futureUsuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum usuário encontrado"));
          }

          final usuarios = snapshot.data!;
          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final u = usuarios[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(getClasseImagePath(u.classe)),
                  ),
                  title: Row(
                    children: [
                      Text(
                        u.nick,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Lv. ${u.nivel}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => alternarAdmin(u),
                        child: Icon(
                          Icons.star,
                          color: u.adm == true ? Colors.amber : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => abrirEditarUsuario(context, u),
                      ),
                      IconButton(
                        icon: const Icon(Icons.lock),
                        onPressed: () => abrirAlterarSenha(context, u),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
