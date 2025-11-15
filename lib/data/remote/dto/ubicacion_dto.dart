class UbicacionDTO {
  final int idUbicacion;
  final int? idPadreUbicacion;
  final String nombreUbicacion;
  final String idDaneUbicacion;
  final String longitudUbicacion;
  final String latitudUbicacion;
  final String? nombrePadre;

  const UbicacionDTO({
    required this.idUbicacion,
    this.idPadreUbicacion,
    required this.nombreUbicacion,
    required this.idDaneUbicacion,
    required this.longitudUbicacion,
    required this.latitudUbicacion,
    this.nombrePadre,
  });

  factory UbicacionDTO.fromJson(Map<String, dynamic> json) {
    return UbicacionDTO(
      idUbicacion: json['idUbicacion'] as int,
      idPadreUbicacion: json['idPadreUbicacion'] as int?,
      nombreUbicacion: json['nombreUbicacion'] as String,
      idDaneUbicacion: json['idDaneUbicacion'] as String,
      longitudUbicacion: json['longitudUbicacion'] as String,
      latitudUbicacion: json['latitudUbicacion'] as String,
      nombrePadre: json['nombrePadre'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'idUbicacion': idUbicacion,
    'idPadreUbicacion': idPadreUbicacion,
    'nombreUbicacion': nombreUbicacion,
    'idDaneUbicacion': idDaneUbicacion,
    'longitudUbicacion': longitudUbicacion,
    'latitudUbicacion': latitudUbicacion,
  };

  @override
  String toString() {
    return 'UbicacionDTO(idUbicacion: $idUbicacion, nombreUbicacion: $nombreUbicacion)';
  }
}