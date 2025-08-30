import 'package:api_cadastro/screen/rules_screen.dart';
import 'package:api_cadastro/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/usuario.dart';
import 'all_souls_screen.dart';
import '../model/evento.dart';
import '../service/evento_service.dart';
import '../service/registro_service.dart';

class HomeScreen extends StatelessWidget {
  final Usuario usuarioLogado;

  const HomeScreen({super.key, required this.usuarioLogado});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          final TabController controller = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Carnificina"),
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Home"),

                  Tab(text: "All Souls"),
                  Tab(text: "Regras"),
                ],
              ),
            ),
            body: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return IndexedStack(
                  index: controller.index,
                  children: [
                    _buildHomeTab(context),

                    const AllSouls(),
                    const RulesScreen(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Coluna de Eventos ---
          Expanded(
            flex: 2,
            child: RegistroEventoScreenContent(usuarioLogado: usuarioLogado),
          ),

          const SizedBox(width: 24),

          // --- Coluna de Perfil / Sair ---
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Bem-vindo!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    _abrirEditarPerfil(context, usuarioLogado.nick);
                  },
                  child: const Text("Perfil"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove(
                      'usuarioLogado',
                    ); // limpa o usuário logado
                    context.go("/login"); // volta para a tela de login
                  },
                  child: const Text("Sair da Conta"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Eventos ---
class RegistroEventoScreenContent extends StatefulWidget {
  final Usuario usuarioLogado;
  const RegistroEventoScreenContent({super.key, required this.usuarioLogado});

  @override
  State<RegistroEventoScreenContent> createState() =>
      _RegistroEventoScreenContentState();
}

class _RegistroEventoScreenContentState
    extends State<RegistroEventoScreenContent> {
  List<Evento> eventos = [];
  bool isLoading = true;
  Set<int> eventosRegistrados = {};

  late TabController _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = DefaultTabController.of(context);

    _tabController.addListener(() {
      if (_tabController.index == 0 && !_tabController.indexIsChanging) {
        // Aba "Home" selecionada
        _carregarEventos();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    setState(() => isLoading = true);
    try {
      final lista = await EventoService.listarEventos();
      setState(() {
        eventos = lista;
      });

      // --- depois que os eventos foram carregados, pegar os registros do usuário ---
      Set<int> registrados = {};
      for (var e in lista) {
        if (e.id != null) {
          final r = await RegistroEventoService.listarEventosRegistrados(
            e.id!,
            widget.usuarioLogado.nick,
          );
          registrados.addAll(r);
        }
      }

      setState(() {
        eventosRegistrados = registrados;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao carregar eventos: $e")));
    }
  }

  Future<void> _registrarNoEvento(int eventoId) async {
    try {
      await RegistroEventoService.adicionarRegistro(
        eventoId,
        widget.usuarioLogado.nick,
      );
      setState(() => eventosRegistrados.add(eventoId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("Registrado com sucesso!"),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao registrar: $e")));
    }
  }

  Future<void> _sairDoEvento(int eventoId) async {
    try {
      await RegistroEventoService.deletarRegistroPorEventoENick(
        eventoId,
        widget.usuarioLogado.nick,
      );
      setState(() => eventosRegistrados.remove(eventoId));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saiu do evento!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao sair do evento: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return ListView.builder(
      shrinkWrap: true,
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final evento = eventos[index];
        final jaRegistrado = eventosRegistrados.contains(evento.id);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Descrição: ${evento.descricao ?? '-'}"),
                const SizedBox(height: 4),
                Text("Data do Evento: ${evento.dataEvento.toLocal()}"),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: Icon(jaRegistrado ? Icons.exit_to_app : Icons.login),
                    label: Text(jaRegistrado ? "Sair" : "Participar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jaRegistrado ? Colors.red : null,
                    ),
                    onPressed: () => jaRegistrado
                        ? _sairDoEvento(evento.id!)
                        : _registrarNoEvento(evento.id!),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Editar Perfil ---
void _abrirEditarPerfil(BuildContext context, String nick) async {
  Usuario usuarioBanco;
  try {
    usuarioBanco = await UsuarioService.getUsuarioPorNick(nick);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Erro ao carregar perfil: $e")));
    return;
  }

  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController(text: usuarioBanco.nome);
  final telefoneController = TextEditingController(text: usuarioBanco.telefone);
  final emailController = TextEditingController(text: usuarioBanco.email);
  final nickController = TextEditingController(text: usuarioBanco.nick);
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  // --- separar nível e fusion ---
  String nivelBase = usuarioBanco.nivel.contains("+")
      ? usuarioBanco.nivel.split("+")[0]
      : usuarioBanco.nivel;

  String fusionBase = usuarioBanco.nivel.contains("+")
      ? usuarioBanco.nivel.split("+")[1]
      : "";

  final nivelController = TextEditingController(text: nivelBase);
  final fusionController = TextEditingController(text: fusionBase);

  bool mostrarFusion = fusionBase.isNotEmpty;

  // --- classe inicial ---
  String classeSelecionada = usuarioBanco.classe;

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

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Editar Perfil"),
        content: SizedBox(
          width: double.maxFinite,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(labelText: "Nome"),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Informe o nome";
                          final regex = RegExp(r'^[A-Za-zÀ-ú\s]+$');
                          if (!regex.hasMatch(v)) return "Nome inválido";
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: telefoneController,
                        decoration: const InputDecoration(
                          labelText: "Telefone (+55 XX XXXXXXXX)",
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return "Informe o telefone";
                          final regex = RegExp(r'^\+\d{1,3}\s?\d{4,14}$');
                          if (!regex.hasMatch(v)) return "Telefone inválido";
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
                        decoration: const InputDecoration(labelText: "Classe"),
                        items: classesValidas.map((classe) {
                          return DropdownMenuItem(
                            value: classe,
                            child: Text(classe.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (valor) {
                          setState(() {
                            classeSelecionada = valor!;
                          });
                        },
                      ),
                      TextFormField(
                        controller: nivelController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Nível (1-120)",
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Informe o nível";
                          final n = int.tryParse(v);
                          if (n == null) return "Digite um número válido";
                          if (n < 1 || n > 120)
                            return "Nível deve ser entre 1 e 120";
                          return null;
                        },
                        onChanged: (v) {
                          final n = int.tryParse(v) ?? 0;
                          setState(() {
                            mostrarFusion = n == 120;
                          });
                        },
                      ),
                      if (mostrarFusion)
                        TextFormField(
                          controller: fusionController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Fusion Level (≥120)",
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Informe o Fusion Level";
                            }
                            final f = int.tryParse(v);
                            if (f == null) return "Digite um número válido";
                            if (f < 120) {
                              return "Fusion Level deve ser 120 ou mais";
                            }
                            return null;
                          },
                        ),
                      TextFormField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Senha"),
                        validator: (v) => v == null || v.length < 4
                            ? "Mínimo 4 caracteres"
                            : null,
                      ),
                      TextFormField(
                        controller: confirmarSenhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirmar Senha",
                        ),
                        validator: (v) => v != senhaController.text
                            ? "Senhas não coincidem"
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              String nivelFinal = nivelController.text;
              if (mostrarFusion && fusionController.text.isNotEmpty) {
                nivelFinal = "$nivelFinal+${fusionController.text}";
              }

              final usuarioAtualizado = Usuario(
                id: usuarioBanco.id,
                nome: nomeController.text,
                telefone: telefoneController.text,
                email: emailController.text,
                nick: nickController.text,
                classe: classeSelecionada,
                nivel: nivelFinal,
                senha: senhaController.text.isNotEmpty
                    ? senhaController.text
                    : usuarioBanco.senha,
                dataConfirmacao: usuarioBanco.dataConfirmacao,
                adm: usuarioBanco.adm,
              );

              try {
                final mensagem = await UsuarioService.atualizarUsuario(
                  usuarioAtualizado,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(mensagem)));
                  Navigator.of(context).pop();
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Erro: $e")));
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      );
    },
  );
}
