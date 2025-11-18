import 'package:oasis/domain/model/verificacion_correo.dart';
import 'package:oasis/domain/repository/verificacion_correo_repositorio.dart';

class ObtenerEstadoVerificacionCasoUso {
  final VerificacionCorreoRepositorio _repositorio;

  ObtenerEstadoVerificacionCasoUso(this._repositorio);

  Future<VerificacionCorreo> call(String correoAcceso) async {
    return await _repositorio.obtenerEstadoVerificacion(correoAcceso);
  }
}