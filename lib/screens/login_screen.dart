import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/login_user.dart';
import 'people_list_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await ApiService.login(
        loginOuEmail: _loginCtrl.text.trim(),
        senha: _senhaCtrl.text.trim(),
      );
      if (user == null) {
        setState(() => _error = 'Credenciais inválidas.');
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, PeopleListScreen.route);
      }
    } catch (e) {
      setState(() => _error = 'Falha no login: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _loginCtrl,
                        decoration: const InputDecoration(labelText: 'Usuário ou E-mail'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe o usuário ou e-mail' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _senhaCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Senha'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe a senha' : null,
                      ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_error!,
                              style: TextStyle(color: theme.colorScheme.error)),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _loading ? null : _doLogin,
                          child: _loading
                              ? const CircularProgressIndicator()
                              : const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não tem uma conta? '),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, RegisterScreen.route),
                            child: const Text('Cadastre-se'),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
