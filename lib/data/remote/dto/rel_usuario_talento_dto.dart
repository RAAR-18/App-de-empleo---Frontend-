class RelUsuarioTalentoDTO {
  final int idUsuario;
  final int idTalento;
  final String nombreTalento;
  final int nivelDominio; // 1 = básico, 2 = intermedio, 3 = avanzado

  RelUsuarioTalentoDTO({
    required this.idUsuario,
    required this.idTalento,
    required this.nombreTalento,
    required this.nivelDominio,
  });

  factory RelUsuarioTalentoDTO.fromJson(Map<String, dynamic> json) {
    return RelUsuarioTalentoDTO(
      idUsuario: json['idUsuario'] as int,
      idTalento: json['idTalento'] as int,
      nombreTalento: json['nombreTalento'] as String,
      nivelDominio: json['nivelDominio'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'idTalento': idTalento,
      'nombreTalento': nombreTalento,
      'nivelDominio': nivelDominio,
    };
  }
}