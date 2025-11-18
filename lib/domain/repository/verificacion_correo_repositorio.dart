import 'package:oasis/domain/model/verificacion_correo.dart';

abstract class VerificacionCorreoRepositorio {
  Future<VerificacionCorreo> enviarCodigoVerificacion(String correoAcceso);
  Future<VerificacionCorreo> verificarCodigo(String correoAcceso, String codigo);
  Future<VerificacionCorreo> obtenerEstadoVerificacion(String correoAcceso);
}