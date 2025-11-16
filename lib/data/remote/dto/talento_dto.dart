class TalentoDTO {
  final int idTalento;
  final String nombre;

  TalentoDTO({
    required this.idTalento,
    required this.nombre,
  });

  factory TalentoDTO.fromJson(Map<String, dynamic> json) {
    return TalentoDTO(
      idTalento: json['idTalento'] as int,
      nombre: json['nombre'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTalento': idTalento,
      'nombre': nombre,
    };
  }
}