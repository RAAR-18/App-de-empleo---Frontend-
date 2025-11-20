import 'package:oasis/data/remote/acceso_info_api.dart';
import 'package:oasis/domain/repository/acceso_info_repositorio.dart';

class AccesoInfoRepositorioImpl implements AccesoInfoRepositorio {
  final AccesoInfoApi _api;

  AccesoInfoRepositorioImpl(this._api);

  @override
  Future<String> obtenerTelefono(int idUsuario) async {
    final response = await _api.obtenerTelefono(idUsuario);

    if (response.codigoEstado == 200 && response.datos != null) {
      return response.datos!;
    } else {
      throw Exception(response.mensaje);
    }
  }
}