import 'package:oasis/data/remote/archivo_api.dart';
import 'package:oasis/domain/model/archivo.dart';
import 'package:oasis/domain/repository/archivo_repositorio.dart';

class ArchivoRepositorioImpl implements ArchivoRepositorio {
  final ArchivoApi _api;

  ArchivoRepositorioImpl(this._api);

  @override
  Future<List<int>> descargarCV(String nombrePrivado) async {
    return await _api.descargarCV(nombrePrivado);
  }

  @override
  Future<void> eliminarCV(int idArchivo) async {
    final respuesta = await _api.eliminarCV(idArchivo);

    if (respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al eliminar CV');
    }
  }

  @override
  Future<Archivo?> obtenerCV(int idUsuario) async {
    final respuesta = await _api.obtenerCV(idUsuario);

    if (respuesta.codigoEstado == 500) {
      throw Exception(respuesta.mensaje ?? 'Error del servidor');
    }


    final dto = respuesta.datos;
    if (dto == null) {
      return null;
    }

    return Archivo(
      idArchivo: dto.idArchivo,
      idUsuario: dto.idUsuario?.idUsuario ?? idUsuario,
      nombrePublicoArchivo: dto.nombrePublicoArchivo,
      nombrePrivadoArchivo: dto.nombrePrivadoArchivo,
      tipoArchivo: dto.tipoArchivo,
      tamanioArchivo: dto.tamanioArchivo,
      grupoArchivo: dto.grupoArchivo,
      fechaSubida: DateTime.parse(dto.fechaSubida),
    );
  }

  @override
  Future<Archivo> subirCV(int idUsuario, String rutaArchivo) async {
    final respuesta = await _api.subirCV(idUsuario, rutaArchivo);

    if (respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al subir CV');
    }

    final dto = respuesta.datos;
    if (dto == null) {
      throw Exception('No se recibieron datos del CV subido');
    }

    return Archivo(
      idArchivo: dto.idArchivo,
      idUsuario: dto.idUsuario?.idUsuario ?? idUsuario,
      nombrePublicoArchivo: dto.nombrePublicoArchivo,
      nombrePrivadoArchivo: dto.nombrePrivadoArchivo,
      tipoArchivo: dto.tipoArchivo,
      tamanioArchivo: dto.tamanioArchivo,
      grupoArchivo: dto.grupoArchivo,
      fechaSubida: DateTime.parse(dto.fechaSubida),
    );
  }
}