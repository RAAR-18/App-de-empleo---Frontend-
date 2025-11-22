import 'package:oasis/domain/model/acceso_info.dart';
import 'package:oasis/domain/repository/acceso_info_repositorio.dart';

class ObtenerInformacionAccesoCasoUso {
  final AccesoInfoRepositorio _repositorio;

  ObtenerInformacionAccesoCasoUso(this._repositorio);

  Future<AccesoInfo> call(int idUsuario) async {
    return await _repositorio.obtenerInformacionAcceso(idUsuario);
  }
}
