class PerfilDTO {
  final int idUsuario;
  final String nombreCompleto;
  final String profesion;
  final String ubicacion;
  final String? fotoPerfil;

  PerfilDTO({
    required this.idUsuario,
    required this.nombreCompleto,
    required this.profesion,
    required this.ubicacion,
    this.fotoPerfil,
  });

  factory PerfilDTO.fromJson(Map<String, dynamic> json) {
    return PerfilDTO(
      idUsuario: json['idUsuario'] as int,
      nombreCompleto: json['nombreCompleto'] as String,
      profesion: json['profesion'] as String,
      ubicacion: json['ubicacion'] as String,
      fotoPerfil: json['fotoPerfil'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombreCompleto': nombreCompleto,
      'profesion': profesion,
      'ubicacion': ubicacion,
      'fotoPerfil': fotoPerfil,
    };
  }
}