import 'package:oasis/data/remote/dto/usuario_dto.dart';

class ArchivoDTO {
  final int idArchivo;
  final UsuarioDTO? idUsuario;
  final String nombrePublicoArchivo;
  final String nombrePrivadoArchivo;
  final String tipoArchivo;
  final String tamanioArchivo;
  final int grupoArchivo;
  final String fechaSubida;

  ArchivoDTO({
    required this.idArchivo,
    this.idUsuario,
    required this.nombrePublicoArchivo,
    required this.nombrePrivadoArchivo,
    required this.tipoArchivo,
    required this.tamanioArchivo,
    required this.grupoArchivo,
    required this.fechaSubida,
  });

  factory ArchivoDTO.fromJson(Map<String, dynamic> json) {
    try {
      if (json['nombrePublicoArchivo'] == null ||
          json['nombrePrivadoArchivo'] == null ||
          json['tipoArchivo'] == null ||
          json['tamanioArchivo'] == null) {
        throw Exception('Datos de archivo incompletos o nulos');
      }

      final tamanio = json['tamanioArchivo'];
      final tamanioStr = tamanio is int ? tamanio.toString() : tamanio as String;

      final archivo = ArchivoDTO(
        idArchivo: json['idArchivo'] as int,
        idUsuario: json['idUsuario'] != null
            ? UsuarioDTO.fromJson(json['idUsuario'] as Map<String, dynamic>)
            : null,
        nombrePublicoArchivo: json['nombrePublicoArchivo'] as String,
        nombrePrivadoArchivo: json['nombrePrivadoArchivo'] as String,
        tipoArchivo: json['tipoArchivo'] as String,
        tamanioArchivo: tamanioStr,
        grupoArchivo: json['grupoArchivo'] as int,
        fechaSubida: json['fechaSubida'] as String,
      );

      return archivo;

    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'idArchivo': idArchivo,
      'idUsuario': idUsuario?.toJson(),
      'nombrePublicoArchivo': nombrePublicoArchivo,
      'nombrePrivadoArchivo': nombrePrivadoArchivo,
      'tipoArchivo': tipoArchivo,
      'tamanioArchivo': tamanioArchivo,
      'grupoArchivo': grupoArchivo,
      'fechaSubida': fechaSubida,
    };
  }
}