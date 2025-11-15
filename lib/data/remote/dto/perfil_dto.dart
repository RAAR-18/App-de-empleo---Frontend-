class PerfilDTO {
  final int idUsuario;
  final String nombreCompleto;
  final String? profesion;  // 👈 Ahora permite null
  final String? ubicacion;  // 👈 Ahora permite null

  PerfilDTO({
    required this.idUsuario,
    required this.nombreCompleto,
    this.profesion,  // 👈 Ya no es required
    this.ubicacion,  // 👈 Ya no es required
  });

  factory PerfilDTO.fromJson(Map<String, dynamic> json) {
    return PerfilDTO(
      idUsuario: json['idUsuario'] as int,
      nombreCompleto: json['nombreCompleto'] as String,
      profesion: json['profesion'] as String?,  // 👈 Cast seguro con ?
      ubicacion: json['ubicacion'] as String?,  // 👈 Cast seguro con ?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombreCompleto': nombreCompleto,
      'profesion': profesion,
      'ubicacion': ubicacion,
    };
  }
}