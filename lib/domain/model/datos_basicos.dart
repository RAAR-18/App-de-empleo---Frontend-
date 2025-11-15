class DatosBasicos {
  final int idUsuario;
  final String nombresUsuario;
  final String apellidosUsuario;
  final String documentoUsuario;
  final String profesion;
  final String ubicacion;
  final int? idUbicacion;

  const DatosBasicos({
    required this.idUsuario,
    required this.nombresUsuario,
    required this.apellidosUsuario,
    required this.documentoUsuario,
    required this.profesion,
    required this.ubicacion,
    this.idUbicacion,
  });

  String get nombreCompleto => '$nombresUsuario $apellidosUsuario';

  DatosBasicos copyWith({
    int? idUsuario,
    String? nombresUsuario,
    String? apellidosUsuario,
    String? documentoUsuario,
    String? profesion,
    String? ubicacion,
    int? idUbicacion,
  }) {
    return DatosBasicos(
      idUsuario: idUsuario ?? this.idUsuario,
      nombresUsuario: nombresUsuario ?? this.nombresUsuario,
      apellidosUsuario: apellidosUsuario ?? this.apellidosUsuario,
      documentoUsuario: documentoUsuario ?? this.documentoUsuario,
      profesion: profesion ?? this.profesion,
      ubicacion: ubicacion ?? this.ubicacion,
      idUbicacion: idUbicacion ?? this.idUbicacion,
    );
  }

  @override
  String toString() {
    return 'DatosBasicos(idUsuario: $idUsuario, nombresUsuario: $nombresUsuario, '
        'apellidosUsuario: $apellidosUsuario, documentoUsuario: $documentoUsuario, '
        'profesion: $profesion, ubicacion: $ubicacion, idUbicacion: $idUbicacion)';
  }

  @override
  bool operator ==(Object other) {
    return other is DatosBasicos && other.idUsuario == idUsuario;
  }

  @override
  int get hashCode => idUsuario.hashCode;
}