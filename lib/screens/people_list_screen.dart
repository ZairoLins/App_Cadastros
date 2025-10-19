import 'package:flutter/material.dart';
import '../models/person.dart';
import '../services/api_service.dart';
import 'person_form_screen.dart';
import 'login_screen.dart';

class PeopleListScreen extends StatefulWidget {
  static const route = '/people';
  const PeopleListScreen({super.key});

  @override
  State<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  late Future<List<Person>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getPeople();
  }

  Future<void> _reload() async {
    setState(() {
      _future = ApiService.getPeople();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas Cadastradas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.route);
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: RefreshIndicator(
            onRefresh: _reload,
            child: FutureBuilder<List<Person>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Erro: ${snap.error}'));
                }
                final people = snap.data ?? [];
                if (people.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhuma pessoa cadastrada ainda.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: people.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final p = people[i];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        title: Text(
                          p.nome,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'CPF: ${p.cpf}\nTelefone: ${p.telefone}',
                          style: const TextStyle(height: 1.4),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(Icons.edit,
                              color: theme.colorScheme.primary),
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              PersonFormScreen.route,
                              arguments: PersonFormArgs(editing: p),
                            );
                            _reload();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            PersonFormScreen.route,
            arguments: const PersonFormArgs(editing: null),
          );
          _reload();
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}
