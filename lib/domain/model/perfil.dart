class Perfil {
  final int idUsuario;
  final String nombreCompleto;
  final String profesion;
  final String ubicacion;

  const Perfil({
    required this.idUsuario,
    required this.nombreCompleto,
    required this.profesion,
    required this.ubicacion,
  });

  Perfil copyWith({
    int? idUsuario,
    String? nombreCompleto,
    String? profesion,
    String? ubicacion,
    String? fotoPerfil,
  }) {
    return Perfil(
      idUsuario: idUsuario ?? this.idUsuario,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      profesion: profesion ?? this.profesion,
      ubicacion: ubicacion ?? this.ubicacion,
    );
  }

  @override
  String toString() {
    return 'Perfil(idUsuario: $idUsuario, nombreCompleto: $nombreCompleto, '
        'profesion: $profesion, ubicacion: $ubicacion)';
  }

  @override
  bool operator ==(Object other) {
    return other is Perfil && other.idUsuario == idUsuario;
  }

  @override
  int get hashCode => idUsuario.hashCode;
}
