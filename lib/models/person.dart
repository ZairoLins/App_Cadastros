class Person {
  final String id;
  final String nome;
  final String cpf;
  final String telefone;

  Person({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  factory Person.fromJson(Map<String, dynamic> j) => Person(
        id: j['id']?.toString() ?? '',
        nome: j['nome']?.toString() ?? '',
        cpf: j['cpf']?.toString() ?? '',
        telefone: j['telefone']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'cpf': cpf,
        'telefone': telefone,
      };
}
