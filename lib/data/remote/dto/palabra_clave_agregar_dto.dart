class PalabraClaveAgregarDTO {
  final int idUsuario;
  final List<String> palabrasClave;

  PalabraClaveAgregarDTO({
    required this.idUsuario,
    required this.palabrasClave,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'palabrasClave': palabrasClave,
    };
  }
}