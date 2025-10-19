import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/people_list_screen.dart';
import 'screens/person_form_screen.dart';

void main() {
  runApp(const AppA1());
}

class AppA1 extends StatelessWidget {
  const AppA1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_a1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7E57C2),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          filled: true,
          fillColor: Color(0xFFF8F7FA),
        ),
      ),
      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (_) => const LoginScreen(),
        RegisterScreen.route: (_) => const RegisterScreen(),
        PeopleListScreen.route: (_) => const PeopleListScreen(),
        PersonFormScreen.route: (_) => const PersonFormScreen(),
      },
    );
  }
}
