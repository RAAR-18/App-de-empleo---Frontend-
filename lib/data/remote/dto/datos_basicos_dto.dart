class DatosBasicosDTO {
  final int idUsuario;
  final String nombresUsuario;
  final String apellidosUsuario;
  final String documentoUsuario;
  final String profesion;
  final String ubicacion;
  final int? idUbicacion;

  DatosBasicosDTO({
    required this.idUsuario,
    required this.nombresUsuario,
    required this.apellidosUsuario,
    required this.documentoUsuario,
    required this.profesion,
    required this.ubicacion,
    this.idUbicacion,
  });

  factory DatosBasicosDTO.fromJson(Map<String, dynamic> json) {
    return DatosBasicosDTO(
      idUsuario: json['idUsuario'] as int,
      nombresUsuario: json['nombresUsuario'] as String,
      apellidosUsuario: json['apellidosUsuario'] as String,
      documentoUsuario: json['documentoUsuario'] as String,
      profesion: json['profesion'] as String,
      ubicacion: json['ubicacion'] as String,
      idUbicacion: json['idUbicacion'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombresUsuario': nombresUsuario,
      'apellidosUsuario': apellidosUsuario,
      'documentoUsuario': documentoUsuario,
      'profesion': profesion,
      'ubicacion': ubicacion,
      'idUbicacion': idUbicacion,
    };
  }

  @override
  String toString() {
    return 'DatosBasicosDTO(idUsuario: $idUsuario, nombresUsuario: $nombresUsuario, '
        'apellidosUsuario: $apellidosUsuario, documentoUsuario: $documentoUsuario, '
        'profesion: $profesion, ubicacion: $ubicacion, idUbicacion: $idUbicacion)';
  }
}