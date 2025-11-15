import 'package:oasis/domain/model/datos_basicos.dart';
import 'package:oasis/domain/repository/datos_basicos_repositorio.dart';

class ActualizarDatosBasicosCasoUso {
  final DatosBasicosRepository _repository;

  ActualizarDatosBasicosCasoUso(this._repository);

  Future<void> call(DatosBasicos datosActualizados) async {
    return await _repository.actualizarDatosBasicos(datosActualizados);
  }
}