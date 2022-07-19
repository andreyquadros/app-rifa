class Comprador {
  String nome;
  String telefone;
  String endereco;
  String vendedor;


  Comprador({required this.nome, required this.telefone, required this.endereco, required this.vendedor});


  Map<String, dynamic> toMap(){
    return {
    'nome': nome,
    'telefone' : telefone,
    'endereco': endereco,
    'vendedor' : vendedor


    };
  }


}