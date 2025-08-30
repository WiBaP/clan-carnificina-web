import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../model/evento.dart';
import '../model/usuario.dart';
import '../service/evento_service.dart';
import '../service/registro_service.dart';
import '../service/usuario_service.dart';

class RegistroEventoScreen extends StatefulWidget {
  final Usuario usuarioLogado;

  const RegistroEventoScreen({Key? key, required this.usuarioLogado})
    : super(key: key);

  @override
  State<RegistroEventoScreen> createState() => _RegistroEventoScreenState();
}

class _RegistroEventoScreenState extends State<RegistroEventoScreen> {
  List<Evento> eventos = [];
  bool isLoading = true;

  late TabController _tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabController = DefaultTabController.of(context);

    _tabController.addListener(() {
      if (_tabController.index == 0 && !_tabController.indexIsChanging) {
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
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao carregar eventos: $e")));
      }
    }
  }

  // --- Função para gerar 4 PTs aplicando regras de full buff ---
  String gerarParties(List<Usuario> usuarios) {
    // separa por classe
    List<Usuario> fullBuff = usuarios
        .where(
          (u) => [
            "assassin",
            "atalanta",
            "archer",
            "shaman",
            "priestess",
          ].contains(u.classe.toLowerCase()),
        )
        .toList();
    List<Usuario> mecanicos = usuarios
        .where((u) => u.classe.toLowerCase() == "mechanician")
        .toList();
    List<Usuario> outros = usuarios
        .where(
          (u) => ![
            "assassin",
            "atalanta",
            "archer",
            "shaman",
            "priestess",
            "mechanician",
          ].contains(u.classe.toLowerCase()),
        )
        .toList();

    // Inicializa 4 PTs
    List<Usuario> pt1 = [];
    List<Usuario> pt2 = [];
    List<Usuario> pt3 = [];
    List<Usuario> pt4 = [];

    // ---- 1) Distribuir Full Buffs ----
    int fullBuffIdx = 0;
    for (var fb in fullBuff) {
      if (fullBuffIdx % 2 == 0) {
        if (pt1.length < 6)
          pt1.add(fb);
        else if (pt2.length < 6)
          pt2.add(fb);
        else if (pt3.length < 6)
          pt3.add(fb);
        else if (pt4.length < 6)
          pt4.add(fb);
      } else {
        if (pt3.length < 6)
          pt3.add(fb);
        else if (pt4.length < 6)
          pt4.add(fb);
        else if (pt1.length < 6)
          pt1.add(fb);
        else if (pt2.length < 6)
          pt2.add(fb);
      }
      fullBuffIdx++;
    }

    // ---- 2) Distribuir Mecânicos ----
    for (var m in mecanicos) {
      if (pt1.length < 6) {
        pt1.add(m);
      } else if (pt2.length < 6) {
        pt2.add(m);
      } else if (pt3.length < 6) {
        pt3.add(m);
      } else if (pt4.length < 6) {
        pt4.add(m);
      }
    }

    // ---- 3) Distribuir resto ----
    List<List<Usuario>> pts = [pt1, pt2, pt3, pt4];
    int idx = 0;
    for (var j in outros) {
      while (pts[idx % 4].length >= 6) idx++;
      pts[idx % 4].add(j);
      idx++;
    }

    String formatar(List<Usuario> lista) {
      return lista
          .map((u) => "- ${u.classe} (${u.nick}) [Lv.${u.nivel}]")
          .join("\n");
    }

    return """
PT1 (Raid1)
${formatar(pt1)}

PT2 (Raid1)
${formatar(pt2)}

PT3 (Raid2)
${formatar(pt3)}

PT4 (Raid2)
${formatar(pt4)}
""";
  }

  // --- pega os registrados e busca dados do usuário ---
  Future<void> _mostrarUsuariosRegistrados(int eventoId) async {
    try {
      final registrados = await RegistroEventoService.listarPorEvento(eventoId);

      if (!mounted) return;

      if (registrados.isEmpty) {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text("Usuários inscritos"),
            content: const Text("Nenhum usuário inscrito"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("Fechar"),
              ),
            ],
          ),
        );
        return;
      }

      final futures = registrados.map((r) async {
        try {
          final u = await UsuarioService.getUsuarioPorNick(r.nick);
          return u;
        } catch (_) {
          return null;
        }
      }).toList();

      final usuariosEncontrados = await Future.wait(futures);
      final usuariosValidos = usuariosEncontrados.whereType<Usuario>().toList();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Usuários inscritos"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: registrados.length,
              itemBuilder: (_, index) {
                final reg = registrados[index];
                final Usuario? usuario = usuariosEncontrados[index];

                final nick = reg.nick;
                final classe = usuario!.classe;
                final nivel = usuario.nivel;

                final imagemClasse = _imagemDaClasse(classe);

                return ListTile(
                  leading: Image.asset(
                    imagemClasse,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  title: Text(nick),
                  subtitle: Text("Level: $nivel"),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Fechar"),
            ),
            ElevatedButton(
              onPressed: () {
                final resultado = gerarParties(usuariosValidos);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Parties Geradas"),
                    content: SingleChildScrollView(
                      child: SelectableText(resultado),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: resultado));
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Copiado para área de transferência",
                              ),
                            ),
                          );
                        },
                        child: const Text("Copiar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Fechar"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Gerar PTs"),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar registros: $e")),
        );
      }
    }
  }

  String _imagemDaClasse(String? classe) {
    switch (classe?.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final evento = eventos[index];

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(evento.titulo),
            subtitle: Text(evento.descricao ?? '-'),
            trailing: Text(DateFormat('dd/MM/yyyy').format(evento.dataEvento)),
            onTap: () => _mostrarUsuariosRegistrados(evento.id!),
          ),
        );
      },
    );
  }
}
