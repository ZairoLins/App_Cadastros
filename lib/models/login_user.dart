class LoginUser {
  final String id;
  final String login;
  final String email;
  final String senha;

  LoginUser({
    required this.id,
    required this.login,
    required this.email,
    required this.senha,
  });

  factory LoginUser.fromJson(Map<String, dynamic> j) => LoginUser(
        id: j['id']?.toString() ?? '',
        login: j['login']?.toString() ?? '',
        email: j['email']?.toString() ?? '',
        senha: j['senha']?.toString() ?? '',
      );
}
