import 'package:oasis/domain/model/datos_basicos.dart';
import 'package:oasis/domain/repository/datos_basicos_repositorio.dart';

class ObtenerDatosBasicosUseCase {
  final DatosBasicosRepository _repository;

  ObtenerDatosBasicosUseCase(this._repository);

  Future<DatosBasicos> call(int idUsuario) async {
    return await _repository.obtenerDatosBasicos(idUsuario);
  }
}
