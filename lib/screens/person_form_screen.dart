import 'package:flutter/material.dart';
import '../models/person.dart';
import '../services/api_service.dart';

class PersonFormArgs {
  final Person? editing;
  const PersonFormArgs({required this.editing});
}

class PersonFormScreen extends StatefulWidget {
  static const route = '/person-form';
  const PersonFormScreen({super.key});

  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  bool _saving = false;

  Person? editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is PersonFormArgs) {
      editing = args.editing;
      if (editing != null) {
        _nomeCtrl.text = editing!.nome;
        _cpfCtrl.text = editing!.cpf;
        _telCtrl.text = editing!.telefone;
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final payload = Person(
        id: editing?.id ?? '',
        nome: _nomeCtrl.text.trim(),
        cpf: _cpfCtrl.text.trim(),
        telefone: _telCtrl.text.trim(),
      );

      if (editing == null) {
        await ApiService.createPerson(payload);
      } else {
        await ApiService.updatePerson(editing!.id, payload);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro salvo com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (editing == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir'),
        content: Text('Excluir ${editing!.nome}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir')),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await ApiService.deletePerson(editing!.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro excluído com sucesso.')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = editing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Pessoa' : 'Nova Pessoa'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isEdit
                              ? 'Editar Cadastro'
                              : 'Novo Cadastro de Pessoa',
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nomeCtrl,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe o nome' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cpfCtrl,
                        decoration: const InputDecoration(labelText: 'CPF'),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe o CPF' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _telCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Telefone'),
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Informe o telefone'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _saving ? null : _save,
                              icon: const Icon(Icons.save),
                              label: const Text('Salvar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (isEdit)
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: _saving ? null : _delete,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Excluir'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
