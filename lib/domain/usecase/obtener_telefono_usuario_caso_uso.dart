import '../repository/acceso_info_repositorio.dart';

class ObtenerTelefonoUsuarioCasoUso {
  final AccesoInfoRepositorio _repositorio;

  ObtenerTelefonoUsuarioCasoUso(this._repositorio);

  Future<String> call(int idUsuario) async {
    if (idUsuario <= 0) {
      throw Exception('ID de usuario inválido');
    }

    return await _repositorio.obtenerTelefono(idUsuario);
  }
}