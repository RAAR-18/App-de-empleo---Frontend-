import 'package:oasis/data/remote/dto/ubicacion_dto.dart';

class UsuarioDTO {
  final int idUsuario;
  final UbicacionDTO? idUbicacion;
  final String? documentoUsuario;
  final String? nombresUsuario;
  final String? apellidosUsuario;
  final int? estadoUsuario;
  final String? profesion;

  UsuarioDTO({
    required this.idUsuario,
    this.idUbicacion,
    this.documentoUsuario,
    this.nombresUsuario,
    this.apellidosUsuario,
    this.estadoUsuario,
    this.profesion,
  });

  factory UsuarioDTO.fromJson(Map<String, dynamic> json) {
      final usuario = UsuarioDTO(
        idUsuario: json['idUsuario'] as int,
        idUbicacion: json['idUbicacion'] != null
            ? UbicacionDTO.fromJson(json['idUbicacion'] as Map<String, dynamic>)
            : null,
        documentoUsuario: json['documentoUsuario'] as String?,
        nombresUsuario: json['nombresUsuario'] as String?,
        apellidosUsuario: json['apellidosUsuario'] as String?,
        estadoUsuario: json['estadoUsuario'] as int?,
        profesion: json['profesion'] as String?,
      );
      return usuario;
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'idUbicacion': idUbicacion?.toJson(),
      'documentoUsuario': documentoUsuario,
      'nombresUsuario': nombresUsuario,
      'apellidosUsuario': apellidosUsuario,
      'estadoUsuario': estadoUsuario,
      'profesion': profesion,
    };
  }

  String get nombreCompleto {
    final nombres = nombresUsuario?.trim() ?? '';
    final apellidos = apellidosUsuario?.trim() ?? '';
    return '$nombres $apellidos'.trim();
  }
}