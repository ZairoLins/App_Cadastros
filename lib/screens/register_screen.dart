import 'package:flutter/material.dart';
import '../models/login_user.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  static const route = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final user = LoginUser(
        id: '',
        login: _loginCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        senha: _senhaCtrl.text.trim(),
      );
      await ApiService.createLogin(user);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
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
                    TextFormField(
                      controller: _loginCtrl,
                      decoration: const InputDecoration(labelText: 'Login'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe o login' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe o e-mail' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _senhaCtrl,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const CircularProgressIndicator()
                            : const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
