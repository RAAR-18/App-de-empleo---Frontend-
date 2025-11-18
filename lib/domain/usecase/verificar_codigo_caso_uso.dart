import 'package:oasis/domain/model/verificacion_correo.dart';
import 'package:oasis/domain/repository/verificacion_correo_repositorio.dart';

class VerificarCodigoCasoUso {
  final VerificacionCorreoRepositorio _repositorio;

  VerificarCodigoCasoUso(this._repositorio);

  Future<VerificacionCorreo> call(String correoAcceso, String codigo) async {
    return await _repositorio.verificarCodigo(correoAcceso, codigo);
  }
}