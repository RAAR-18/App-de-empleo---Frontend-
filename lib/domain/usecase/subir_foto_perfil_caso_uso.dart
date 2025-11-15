import 'package:oasis/domain/repository/imagen_repositorio.dart';

class SubirFotoPerfilCasoUso {
  final ImagenRepository _repository;

  SubirFotoPerfilCasoUso(this._repository);

  Future<void> call(int idUsuario, String rutaArchivo) async {
    return await _repository.subirFotoPerfil(idUsuario, rutaArchivo);
  }
}