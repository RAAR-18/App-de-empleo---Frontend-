import 'package:oasis/data/remote/imagen_api.dart';
import 'package:oasis/domain/repository/imagen_repositorio.dart';

class ImagenRepositoryImpl implements ImagenRepository {
  final ImagenApi _api;

  ImagenRepositoryImpl(this._api);

  @override
  Future<String?> obtenerFotoPerfil(int idUsuario) async {
    try {
      final respuesta = await _api.obtenerFotoPerfil(idUsuario);

      if (respuesta.datos == null) {
        return null;
      }

      // Extraer la URL de la imagen
      final urlImagen = respuesta.datos!['urlImagen'] as String?;
      return urlImagen;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> subirFotoPerfil(int idUsuario, String rutaArchivo) async {
    final respuesta = await _api.subirFotoPerfil(
      idUsuario: idUsuario,
      rutaArchivo: rutaArchivo,
    );

    if (respuesta.datos == null || respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al subir foto de perfil');
    }
  }
}
