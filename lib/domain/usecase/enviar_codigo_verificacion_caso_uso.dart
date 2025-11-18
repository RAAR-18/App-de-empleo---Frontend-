import 'package:oasis/domain/model/verificacion_correo.dart';
import 'package:oasis/domain/repository/verificacion_correo_repositorio.dart';

class EnviarCodigoVerificacionCasoUso {
  final VerificacionCorreoRepositorio _repositorio;

  EnviarCodigoVerificacionCasoUso(this._repositorio);

  Future<VerificacionCorreo> call(String correoAcceso) async {
    return await _repositorio.enviarCodigoVerificacion(correoAcceso);
  }
}