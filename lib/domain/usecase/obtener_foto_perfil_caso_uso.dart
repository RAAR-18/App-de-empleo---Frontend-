import 'package:oasis/domain/repository/imagen_repositorio.dart';

class ObtenerFotoPerfilCasoUso {
  final ImagenRepository _repository;

  ObtenerFotoPerfilCasoUso(this._repository);

  Future<String?> call(int idUsuario) async {
    return await _repository.obtenerFotoPerfil(idUsuario);
  }
}