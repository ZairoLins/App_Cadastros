import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_user.dart';
import '../models/person.dart';

class ApiService {
  static const String baseUrl = 'https://68f138f90b966ad50035be96.mockapi.io';

  static Future<LoginUser?> login({
    required String loginOuEmail,
    required String senha,
  }) async {
    final byLogin = await http.get(
      Uri.parse('$baseUrl/login?login=$loginOuEmail&senha=$senha'),
    );
    final byEmail = await http.get(
      Uri.parse('$baseUrl/login?email=$loginOuEmail&senha=$senha'),
    );

    if (byLogin.statusCode == 200 || byEmail.statusCode == 200) {
      final List listA =
          byLogin.statusCode == 200 ? jsonDecode(byLogin.body) : [];
      final List listB =
          byEmail.statusCode == 200 ? jsonDecode(byEmail.body) : [];
      final merged = [...listA, ...listB];
      if (merged.isNotEmpty) return LoginUser.fromJson(merged.first);
    }
    return null;
  }

  static Future<LoginUser> createLogin(LoginUser user) async {
    final r = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': user.login,
        'email': user.email,
        'senha': user.senha,
      }),
    );
    if (r.statusCode == 201 || r.statusCode == 200) {
      return LoginUser.fromJson(jsonDecode(r.body));
    }
    throw Exception('Erro ao criar login: ${r.statusCode}');
  }

  static Future<List<Person>> getPeople() async {
    final r = await http.get(Uri.parse('$baseUrl/pessoa'));
    if (r.statusCode == 200) {
      final data = (jsonDecode(r.body) as List).cast<Map<String, dynamic>>();
      return data.map(Person.fromJson).toList();
    }
    throw Exception('Falha ao carregar pessoas: ${r.statusCode}');
  }

  static Future<Person> createPerson(Person p) async {
    final r = await http.post(
      Uri.parse('$baseUrl/pessoa'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (r.statusCode == 201 || r.statusCode == 200) {
      return Person.fromJson(jsonDecode(r.body));
    }
    throw Exception('Erro ao criar pessoa: ${r.statusCode}');
  }

  static Future<Person> updatePerson(String id, Person p) async {
    final r = await http.put(
      Uri.parse('$baseUrl/pessoa/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (r.statusCode == 200) {
      return Person.fromJson(jsonDecode(r.body));
    }
    throw Exception('Erro ao atualizar pessoa: ${r.statusCode}');
  }

  static Future<void> deletePerson(String id) async {
    final r = await http.delete(Uri.parse('$baseUrl/pessoa/$id'));
    if (r.statusCode != 200) {
      throw Exception('Erro ao excluir pessoa: ${r.statusCode}');
    }
  }
}
