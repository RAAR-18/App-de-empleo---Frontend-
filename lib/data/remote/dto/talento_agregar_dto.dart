class TalentoAgregarDTO {
  final int idUsuario;
  final int idTalento;
  final int nivelDominio; // 1 = básico, 2 = intermedio, 3 = avanzado

  TalentoAgregarDTO({
    required this.idUsuario,
    required this.idTalento,
    required this.nivelDominio,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'idTalento': idTalento,
      'nivelDominio': nivelDominio,
    };
  }
}