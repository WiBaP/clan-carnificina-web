import 'package:flutter/material.dart';
import '../model/evento.dart';
import '../service/evento_service.dart';
import 'package:intl/intl.dart';

class EventoScreen extends StatefulWidget {
  const EventoScreen({super.key});

  @override
  State<EventoScreen> createState() => _EventoScreenState();
}

class _EventoScreenState extends State<EventoScreen>
    with TickerProviderStateMixin {
  List<Evento> eventos = [];
  bool isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // Atualiza eventos sempre que a aba "Listar" for selecionada
        _carregarEventos();
      }
    });
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    setState(() => isLoading = true);
    try {
      final lista = await EventoService.listarEventos();
      setState(() => eventos = lista);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao carregar eventos: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Cadastrar"),
            Tab(text: "Listar"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCadastrarTab(context), _buildListarTab(context)],
      ),
    );
  }

  Widget _buildCadastrarTab(BuildContext context) {
    final brasilFormat = DateFormat('dd/MM/yyyy HH:mm');
    final _formKey = GlobalKey<FormState>();
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();
    final TextEditingController dataEventoController = TextEditingController();
    final TextEditingController inicioInscricaoController =
        TextEditingController();
    final TextEditingController fimInscricaoController =
        TextEditingController();
    final TextEditingController limiteController =
        TextEditingController(); // novo

    bool isLoading = false;

    Future<void> _pickDateTime(TextEditingController controller) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (pickedDate == null) return;

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime == null) return;

      final combined = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      controller.text = brasilFormat.format(combined);
    }

    Future<void> _cadastrarEvento() async {
      if (!_formKey.currentState!.validate()) return;

      DateTime dataEvento = brasilFormat.parse(dataEventoController.text);
      DateTime inicioInscricao = brasilFormat.parse(
        inicioInscricaoController.text,
      );
      DateTime fimInscricao = brasilFormat.parse(fimInscricaoController.text);
      int? limite = int.tryParse(limiteController.text);

      final novoEvento = Evento(
        titulo: tituloController.text,
        descricao: descricaoController.text,
        dataEvento: dataEvento,
        inicioInscricao: inicioInscricao,
        fimInscricao: fimInscricao,
        status: "ativo",
        limiteParticipantes: limite,
      );

      try {
        setState(() => isLoading = true);
        final msg = await EventoService.cadastrarEvento(novoEvento);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));

        // Limpa campos
        tituloController.clear();
        descricaoController.clear();
        dataEventoController.clear();
        inicioInscricaoController.clear();
        fimInscricaoController.clear();
        limiteController.clear();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
      } finally {
        setState(() => isLoading = false);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: "Título do Evento"),
              validator: (v) =>
                  v == null || v.isEmpty ? "Informe o título" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dataEventoController,
              decoration: const InputDecoration(
                labelText: "Data e Hora do Evento",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDateTime(dataEventoController),
              validator: (v) => v == null || v.isEmpty
                  ? "Informe a data e hora do evento"
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: inicioInscricaoController,
              decoration: const InputDecoration(
                labelText: "Início da Inscrição",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDateTime(inicioInscricaoController),
              validator: (v) => v == null || v.isEmpty
                  ? "Informe a data e hora de início"
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: fimInscricaoController,
              decoration: const InputDecoration(
                labelText: "Fim da Inscrição",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDateTime(fimInscricaoController),
              validator: (v) => v == null || v.isEmpty
                  ? "Informe a data e hora de fim"
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: limiteController,
              decoration: const InputDecoration(
                labelText: "Limite de Participantes",
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty
                  ? "Informe o limite de participantes"
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _cadastrarEvento,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Cadastrar Evento"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// ABA DE LISTAR
  /// =======================
  Widget _buildListarTab(BuildContext context) {
    final brasilFormat = DateFormat('dd/MM/yyyy HH:mm');

    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (eventos.isEmpty)
      return const Center(child: Text("Nenhum evento encontrado"));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        final evento = eventos[index];
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
                Text("Descrição: ${evento.descricao}"),
                const SizedBox(height: 4),
                Text(
                  "Data do Evento: ${brasilFormat.format(evento.dataEvento.toLocal())}",
                ),
                const SizedBox(height: 4),
                Text(
                  "Início da Inscrição: ${brasilFormat.format(evento.inicioInscricao.toLocal())}",
                ),
                const SizedBox(height: 4),
                Text(
                  "Fim da Inscrição: ${brasilFormat.format(evento.fimInscricao.toLocal())}",
                ),
                const SizedBox(height: 4),
                Text("Status: ${evento.status}"),
                const SizedBox(height: 8),
                Text(
                  "Limite de Participantes: ${evento.limiteParticipantes ?? 'Não definido'}",
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _abrirAtualizarEvento(context, evento);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Confirmar exclusão"),
                            content: Text(
                              "Deseja excluir o evento '${evento.titulo}'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Excluir"),
                              ),
                            ],
                          ),
                        );

                        if (confirm ?? false) {
                          try {
                            final msg = await EventoService.excluirEvento(
                              evento.id!,
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(msg)));
                            _carregarEventos();
                          } catch (e) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// =======================
  /// ABA DE ATUALIZAR
  /// =======================
  void _abrirAtualizarEvento(BuildContext context, Evento evento) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildAtualizarTab(context, evento),
      ),
    );
  }

  Widget _buildAtualizarTab(BuildContext context, Evento evento) {
    final brasilFormat = DateFormat('dd/MM/yyyy HH:mm');
    final _formKey = GlobalKey<FormState>();
    final TextEditingController tituloController = TextEditingController(
      text: evento.titulo,
    );
    final TextEditingController descricaoController = TextEditingController(
      text: evento.descricao,
    );
    final TextEditingController dataEventoController = TextEditingController(
      text: brasilFormat.format(evento.dataEvento),
    );
    final TextEditingController inicioInscricaoController =
        TextEditingController(
          text: brasilFormat.format(evento.inicioInscricao),
        );
    final TextEditingController fimInscricaoController = TextEditingController(
      text: brasilFormat.format(evento.fimInscricao),
    );
    String status = evento.status;
    final TextEditingController limiteController = TextEditingController(
      text: evento.limiteParticipantes?.toString(),
    );

    bool isLoading = false;

    Future<void> _pickDateTime(TextEditingController controller) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (pickedDate == null) return;

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime == null) return;

      final combined = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      controller.text = brasilFormat.format(combined);
    }

    Future<void> _atualizarEvento() async {
      if (!_formKey.currentState!.validate()) return;

      final parseDate = (String text) => brasilFormat.parse(text);

      final eventoAtualizado = Evento(
        id: evento.id,
        titulo: tituloController.text,
        descricao: descricaoController.text,
        dataEvento: parseDate(dataEventoController.text),
        inicioInscricao: parseDate(inicioInscricaoController.text),
        fimInscricao: parseDate(fimInscricaoController.text),
        status: status,
        limiteParticipantes: int.tryParse(limiteController.text),
      );

      try {
        setState(() => isLoading = true);
        final msg = await EventoService.atualizarEvento(eventoAtualizado);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        _carregarEventos();
        Navigator.pop(context); // fecha o modal
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
      } finally {
        setState(() => isLoading = false);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: "Título do Evento"),
              validator: (v) =>
                  v == null || v.isEmpty ? "Informe o título" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: "Descrição"),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dataEventoController,
              decoration: const InputDecoration(
                labelText: "Data e Hora do Evento",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDateTime(dataEventoController),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: inicioInscricaoController,
              decoration: const InputDecoration(
                labelText: "Início da Inscrição",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDateTime(inicioInscricaoController),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: fimInscricaoController,
              decoration: const InputDecoration(
                labelText: "Fim da Inscrição",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _pickDateTime(fimInscricaoController),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: limiteController,
              decoration: const InputDecoration(
                labelText: "Limite de Participantes",
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v != null && v.isNotEmpty && int.tryParse(v) == null) {
                  return "Informe um número válido";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: "Status"),
              items: const [
                DropdownMenuItem(value: "ativo", child: Text("Ativo")),
                DropdownMenuItem(value: "cancelado", child: Text("Cancelado")),
                DropdownMenuItem(value: "encerrado", child: Text("Encerrado")),
              ],
              onChanged: (v) {
                if (v != null) status = v;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : _atualizarEvento,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Atualizar Evento"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
