class Vendedor {
  final String id;
  final String nome;

  Vendedor({
    required this.id,
    required this.nome,
  });

  factory Vendedor.fromMap(Map<String, dynamic> map) {
    return Vendedor(
      id: map['id'],
      nome: map['nome'],
    );
  }

  @override
  String toString() => 'Vendedor(nome: $nome)';
}
