class DatosBasicosActualizarDTO {
  final int idUsuario;
  final String nombresUsuario;
  final String apellidosUsuario;
  final String documentoUsuario;
  final String profesion;
  final int idUbicacion;

  DatosBasicosActualizarDTO({
    required this.idUsuario,
    required this.nombresUsuario,
    required this.apellidosUsuario,
    required this.documentoUsuario,
    required this.profesion,
    required this.idUbicacion,
  });

  Map<String, dynamic> toJson() => {
    'idUsuario': idUsuario,
    'nombresUsuario': nombresUsuario,
    'apellidosUsuario': apellidosUsuario,
    'documentoUsuario': documentoUsuario,
    'profesion': profesion,
    'idUbicacion': idUbicacion,
  };

  @override
  String toString() {
    return 'UsuarioActualizarDTO(idUsuario: $idUsuario, nombresUsuario: $nombresUsuario, '
        'apellidosUsuario: $apellidosUsuario, documentoUsuario: $documentoUsuario, '
        'profesion: $profesion, idUbicacion: $idUbicacion)';
  }
}